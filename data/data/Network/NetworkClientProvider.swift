//
//  NetworkClientProvider.swift
//  data
//
//  Created by Karim Karimov on 01.03.21.
//

import Foundation
import Alamofire
import Promises
import domain

class NetworkClientProvider {
    
    // MARK: - Variables
    
    private let baseUrl: String
    private let interceptors: Interceptor
    private let logger: Logger
    
    private let session: Session
    
    // MARK: - Contructor
    
    init(baseUrl: String,
         requestInterceptors: [RequestAdapter],
         requestRetriers: [RequestRetrier],
         logger: Logger,
         networkLogger: NetworkLogger) {
        self.baseUrl = baseUrl
        self.logger = logger
        self.session = Session(eventMonitors: [networkLogger])
        self.interceptors = Interceptor(adapters: requestInterceptors, retriers: requestRetriers)
    }
    
    // MARK: - Functions
    
    func getThrowableError(message: String) -> NSError {
        
        let throwableError = NSError(domain: "", code: 100, userInfo: [
            NSLocalizedDescriptionKey: message
        ])
        
        return throwableError
    }
    
    func request<I: Encodable, O: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders = [:],
        params: I? = nil
    ) -> Promise<O> {
        
        let taskPromise = Promise<O>.pending()
        
        let requestUrl = "\(self.baseUrl)\(url)"
        
        let encoder: ParameterEncoder
        
        switch method {
        case .get:
            encoder = URLEncodedFormParameterEncoder.default
        default:
            encoder = JSONParameterEncoder.default
        }
        
        self.session.request(
            requestUrl,
            method: method,
            parameters: params,
            encoder: encoder,
            headers: headers,
            interceptor: self.interceptors)
            .responseDecodable(completionHandler: { (response : DataResponse<O, AFError>) in
                
                if response.response?.statusCode == 401 {
                    taskPromise.reject(UnauthorizedError())
                    
                    return
                }
                
                if let error = response.error {
                    let responseError = response.data?.getErrorResponse() ?? ErrorResponse(code: "", message: "")
                    let uiError = UIErrorType(rawValue: responseError.code) ?? .unknown
                    
                    self.logger.logDebug(error.localizedDescription)
                    taskPromise.reject(UIError.init(type: uiError))
                    
                    return
                }
                
                guard let data = response.value else {
                    let message = "Error on parsing \(O.self)"
                    self.logger.logDebug(message)
                    taskPromise.reject(ParsingError(description: message))
                    
                    return
                }
                
                taskPromise.fulfill(data)
            })
        
        return taskPromise
    }
}

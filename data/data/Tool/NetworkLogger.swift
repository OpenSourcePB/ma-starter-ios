//
//  NetworkLogger.swift
//  data
//
//  Created by Karim Karimov on 02.03.21.
//

import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    
    private let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }

    func requestDidResume(_ request: Request) {

        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
        let headers = """
        >>> Request Started: \(request)
        >>> Headers: \(allHeaders)
        """
        self.logger.logDebug(headers)


        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        <<< Request Started: \(request)
        <<< Body Data: \(body)
        """
        self.logger.logDebug(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {

        self.logger.logDebug("<<< Response Received: \(response.debugDescription)")
        self.logger.logDebug("<<< Response All Headers: \(String(describing: response.response?.allHeaderFields))")
    }
}

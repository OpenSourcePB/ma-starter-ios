//
//  BaseInterceptor.swift
//  data
//
//  Created by Karim Karimov on 02.03.21.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        let baseHeader: HTTPHeader = HTTPHeader(name: "Accept", value: "application/json")
        
        urlRequest.headers.add(baseHeader)

        completion(.success(urlRequest))
    }
}

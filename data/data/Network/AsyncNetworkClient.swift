//
//  AsyncNetworkClient.swift
//  data
//
//  Created by Rza Ismayilov on 04.08.23.
//

import Foundation
import Alamofire
import domain

protocol AsyncNetworkClientProtocol {
    func request<I: Encodable, O: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        params: I?,
        encoder: ParameterEncoder
    ) async throws -> O
}

class AsyncNetworkClient: AsyncNetworkClientProtocol {

    // MARK: - Variables

    private let baseUrl: String
    private let session: Session
    private let logger: Logger


    // MARK: - Contructor

    init(
        baseUrl: String,
        requestAdapter: [RequestAdapter],
        requestRetriers: [RequestRetrier],
        logger: Logger,
        networkLogger: NetworkLogger
    ) {
        self.baseUrl = baseUrl
        self.logger = logger
        self.session = Session(
            interceptor: Interceptor(
                adapters: requestAdapter,
                retriers: requestRetriers
            ),
            eventMonitors: [networkLogger]
        )
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
        headers: HTTPHeaders,
        params: I?,
        encoder: ParameterEncoder
    ) async throws -> O {
        let response = await self.session.request(
            "\(self.baseUrl)\(url)",
            method: method,
            parameters: params,
            encoder: encoder,
            headers: headers
        ).serializingDecodable(O.self).response

        guard response.response?.statusCode != 401 else {
            throw UnauthorizedError()
        }

        return try response.result.mapError { afError in
            self.logger.logDebug(afError.localizedDescription)

            guard let resErr = response.data?.getErrorResponse()
            else { return afError as Error }

            let uiErrType = UIErrorType(rawValue: resErr.code) ?? .unknown
            return UIError(type: uiErrType) as Error
        }.get()
    }
}


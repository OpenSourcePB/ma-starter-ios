//
//  TransactionRemoteDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Alamofire

class TransactionRemoteDataSource: TransactionRemoteDataSourceProtocol {
    
    private let networkClient: AsyncNetworkClientProtocol
    
    init(networkClient: AsyncNetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getTransactions(of customerId: String, of cardId: String) async throws -> [TransactionRemoteDTO] {
        try await self.networkClient.request(
            url: TransactionAPI.getTransactions(of: customerId, of: cardId),
            method: .get,
            headers: .default,
            params: EmptyParams(),
            encoder: URLEncodedFormParameterEncoder.default
        )
    }
}

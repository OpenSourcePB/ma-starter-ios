//
//  TransactionRemoteDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import Alamofire

class TransactionRemoteDataSource: TransactionRemoteDataSourceProtocol {
    
    private let networkClient: NetworkClientProvider
    
    init(networkClient: NetworkClientProvider) {
        self.networkClient = networkClient
    }
    
    func getTransactions(of customerId: String, of cardId: String) -> Promise<[TransactionRemoteDTO]> {
        self.networkClient.request(
            url: TransactionAPI.getTransactions(of: customerId, of: cardId),
            method: .get,
            params: EmptyParams()
        )
    }
}

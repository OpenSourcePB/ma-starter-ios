//
//  CardRemoteDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import Alamofire

class CardRemoteDataSource: CardRemoteDataSourceProtocol {
    
    private let networkClient: NetworkClientProvider
    
    init(networkClient: NetworkClientProvider) {
        self.networkClient = networkClient
    }
    
    func getCards(by customerId: String) -> Promise<[CardRemoteDTO]> {
        self.networkClient.request(
            url: CardAPI.getCards(of: customerId),
            method: .get,
            params: EmptyParams()
        )
    }
}

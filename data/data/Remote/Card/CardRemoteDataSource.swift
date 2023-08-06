//
//  CardRemoteDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Alamofire

class CardRemoteDataSource: CardRemoteDataSourceProtocol {
    
    private let networkClient: AsyncNetworkClientProtocol
    
    init(networkClient: AsyncNetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getCards(by customerId: String) async throws -> [CardRemoteDTO] {
        try await self.networkClient.request(
            url: CardAPI.getCards(of: customerId),
            method: .get,
            headers: .default,
            params: EmptyParams(),
            encoder: URLEncodedFormParameterEncoder.default
        )
    }
}

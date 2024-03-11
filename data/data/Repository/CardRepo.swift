//
//  CardRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
import Combine

class CardRepo: CardRepoProtocol {
    
    private let localDataSource: CardLocalDataSourceProtocol
    private let remoteDataSource: CardRemoteDataSourceProtocol
    private let customerLocalDataSource: CustomerLocalDataSourceProtocol
    
    init(
        localDataSource: CardLocalDataSourceProtocol,
        remoteDataSource: CardRemoteDataSourceProtocol,
        customerLocalDataSource: CustomerLocalDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.customerLocalDataSource = customerLocalDataSource
    }
    
    func syncCards() async throws {
        let card = try await self.remoteDataSource.getCards(
            by: customerLocalDataSource.getCustomerID()
        ).map { $0.toLocal() }

        try await self.localDataSource.save(cards: card)
    }
    
    func observeCards() -> AnyPublisher<[Card], Never> {
        return self.localDataSource.observeCards()
            .receive(on: DispatchQueue.main)
            .map { localData in
                return localData.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
}

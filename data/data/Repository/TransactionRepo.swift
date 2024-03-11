//
//  TransactionRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
import Combine

class TransactionRepo: TransactionRepoProtocol {
    
    private let localDataSource: TransactionLocalDataSourceProtocol
    private let remoteDataSource: TransactionRemoteDataSourceProtocol
    private let customerLocalDataSource: CustomerLocalDataSourceProtocol
    
    init(
        localDataSource: TransactionLocalDataSourceProtocol,
        remoteDataSource: TransactionRemoteDataSourceProtocol,
        customerLocalDataSource: CustomerLocalDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.customerLocalDataSource = customerLocalDataSource
    }
    
    func syncTransactions(of card: Card) async throws {
        let transactions = try await self.remoteDataSource.getTransactions(
            of: self.customerLocalDataSource.getCustomerID(),
            of: card.id
        ).map { $0.toLocal(cardId: card.id) }

        try await self.localDataSource.save(cardId: card.id, transactions: transactions)
    }
    
    func observeTransactions(of card: Card) -> AnyPublisher<[Transaction], Never> {
        self.localDataSource.observeTransactions(cardId: card.id)
            .receive(on: DispatchQueue.main)
            .map { localDTOs in
                localDTOs.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
}

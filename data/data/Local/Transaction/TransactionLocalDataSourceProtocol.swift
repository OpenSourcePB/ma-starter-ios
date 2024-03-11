//
//  TransactionLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

protocol TransactionLocalDataSourceProtocol {
    func observeTransactions(cardId: String) -> AnyPublisher<[TransactionLocalDTO], Never>
    func save(cardId: String, transactions: [TransactionLocalDTO]) async throws
}


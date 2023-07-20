//
//  TransactionLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine
import Promises

protocol TransactionLocalDataSourceProtocol {
    func observeTransactions(cardId: String) -> AnyPublisher<[TransactionLocalDTO], Never>
    func save(cardId: String, transactions: [TransactionLocalDTO]) -> Promise<Data>
}


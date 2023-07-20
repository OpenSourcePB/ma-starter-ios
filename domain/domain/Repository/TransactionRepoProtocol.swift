//
//  TransactionRepoProtocol.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import Combine

public protocol TransactionRepoProtocol {
    func syncTransactions(of card: Card) -> Promise<Data>
    func observeTransactions(of card: Card) -> AnyPublisher<[Transaction], Never>
}

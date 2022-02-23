//
//  TransactionLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RxSwift
import Promises

protocol TransactionLocalDataSourceProtocol {
    func observeTransactions(cardId: String) -> Observable<[TransactionLocalDTO]>
    func save(cardId: String, transactions: [TransactionLocalDTO]) -> Promise<Data>
}


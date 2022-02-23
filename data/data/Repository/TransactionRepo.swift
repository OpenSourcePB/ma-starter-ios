//
//  TransactionRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
import Promises
import RxSwift

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
    
    func syncTransactions(of card: Card) -> Promise<Data> {
        self.remoteDataSource.getTransactions(of: self.customerLocalDataSource.getCustomerID(), of: card.id)
            .then { data in
                let localData = data.map { remote in
                    remote.toLocal(cardId: card.id)
                }
                return self.localDataSource.save(cardId: card.id, transactions: localData)
            }
    }
    
    func observeTransactions(of card: Card) -> Observable<[Transaction]> {
        return self.localDataSource.observeTransactions(cardId: card.id)
            .map { data in
                return data.map { local in
                    local.toDomain()
                }
            }
    }
}

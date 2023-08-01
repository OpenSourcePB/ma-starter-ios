//
//  TransactionLocalDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RealmSwift
import Realm
import RealmFFI
import Combine
import Promises

class TransactionLocalDataSource: TransactionLocalDataSourceProtocol {
    
    private let realm: Realm
    private let logger: Logger

    private var transactionSubjectMap: Dictionary<String, CurrentValueSubject<[TransactionLocalDTO], Never>> = [:]

    init(realm: Realm,
         logger: Logger) {
        self.realm = realm
        self.logger = logger
    }
    
    private func getTransactionHistory(cardId: String) -> [TransactionLocalDTO] {
        let predicate = NSPredicate(format: "cardId == %@", cardId)

        return self.realm.objects(TransactionLocalDTO.self)
            .filter(predicate)
            .sorted(byKeyPath: "datetime", ascending: false)
            .freeze()
            .map { $0 }
    }
    
    func observeTransactions(cardId: String) -> AnyPublisher<[TransactionLocalDTO], Never> {
        if let observable = self.transactionSubjectMap[cardId]?.eraseToAnyPublisher() {
            return observable
        } else {
            let subject: CurrentValueSubject<[TransactionLocalDTO], Never> = .init(
                self.getTransactionHistory(cardId: cardId)
            )
            self.transactionSubjectMap[cardId] = subject
            return subject.eraseToAnyPublisher()
        }
    }
    
    func save(cardId: String,
              transactions: [TransactionLocalDTO]) -> Promise<Data> {
        let promise = Promise<Data>.pending()
        
        do {
            let predicate = NSPredicate(format: "cardId == %@", cardId)
            
            let cached = self.realm.objects(TransactionLocalDTO.self)
                .filter(predicate)
            
            try self.realm.write {
                self.realm.delete(cached)
                self.realm.add(transactions, update: .modified)
            }
            
            // sync affected cards
            let cardIdMap = Set(transactions.map { (dto) -> String in
                dto.cardId
            })
            
            cardIdMap.forEach { (cardId) in
                self.syncTransactionHistory(cardId: cardId)
            }
            
            // complete action
            promise.fulfill(Data())
        } catch {
            promise.reject(error)
        }
        
        return promise
    }
    
    private func syncTransactionHistory(cardId: String) {
        if let subject = self.transactionSubjectMap[cardId] {
            subject.send(self.getTransactionHistory(cardId: cardId))
        }
    }
}

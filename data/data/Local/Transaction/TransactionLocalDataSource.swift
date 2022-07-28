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
import RxSwift
import RxRelay
import Promises

class TransactionLocalDataSource: TransactionLocalDataSourceProtocol {
    
    private let realm: Realm
    private let logger: Logger
    
    private var transactionRelayMap: Dictionary<String, BehaviorRelay<[TransactionLocalDTO]>>

    init(realm: Realm,
         logger: Logger) {
        self.realm = realm
        self.logger = logger
        self.transactionRelayMap = [:]
    }
    
    private func getTransactionHistory(cardId: String) -> [TransactionLocalDTO] {
        let predicate = NSPredicate(format: "cardId == %@", cardId)

        return self.realm.objects(TransactionLocalDTO.self)
            .filter(predicate)
            .sorted(byKeyPath: "datetime", ascending: false)
            .freeze()
            .map { $0 }
    }
    
    func observeTransactions(cardId: String) -> Observable<[TransactionLocalDTO]> {
        if let observable = self.transactionRelayMap[cardId]?.asObservable() {
            return observable
        } else {
            let relay = BehaviorRelay(value: self.getTransactionHistory(cardId: cardId))
            self.transactionRelayMap[cardId] = relay
            return relay.asObservable()
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
        if let relay = self.transactionRelayMap[cardId] {
            let data = self.getTransactionHistory(cardId: cardId)
            relay.accept(data)
        }
    }
}

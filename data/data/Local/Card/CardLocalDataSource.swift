//
//  CardLocalDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RealmSwift
import RxSwift
import RxRelay
import Promises

class CardLocalDataSource: CardLocalDataSourceProtocol {
    
    private let realm: Realm
    private let logger: Logger
    
    private let cardsRelay: BehaviorRelay<[CardLocalDTO]>
    
    init(realm: Realm,
         logger: Logger) {
        self.realm = realm
        self.logger = logger
        self.cardsRelay = BehaviorRelay<[CardLocalDTO]>.init(value: [])
        self.syncCards()
    }
    
    private func syncCards() {
        let cards = self.getCards()
        self.cardsRelay.accept(cards)
    }
    
    func getCards() -> [CardLocalDTO] {
        return self.realm.objects(CardLocalDTO.self)
            .freeze()
            .map { (item) -> CardLocalDTO in
                item
            }
    }
    
    func observeCards() -> Observable<[CardLocalDTO]> {
        return self.cardsRelay.asObservable()
    }
    
    func save(cards: [CardLocalDTO]) -> Promise<Data> {
        let promise = Promise<Data>.pending()
                
        do {
            let cached = self.realm.objects(CardLocalDTO.self)
            
            try self.realm.write {
                self.realm.delete(cached)
                self.realm.add(cards, update: .modified)
            }
            
            self.syncCards()
            promise.fulfill(Data())
        } catch {
            promise.reject(error)
        }
        
        return promise
    }
}

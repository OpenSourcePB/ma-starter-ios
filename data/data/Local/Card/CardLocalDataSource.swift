//
//  CardLocalDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RealmSwift
import Combine
import Promises

class CardLocalDataSource: CardLocalDataSourceProtocol {
    
    private let realm: Realm
    private let logger: Logger
    
    private let cardsSubject: CurrentValueSubject<[CardLocalDTO], Never> = .init([])
    
    init(realm: Realm,
         logger: Logger) {
        self.realm = realm
        self.logger = logger
        self.syncCards()
    }
    
    private func syncCards() {
        self.cardsSubject.send(self.getCards())
    }
    
    func getCards() -> [CardLocalDTO] {
        return self.realm.objects(CardLocalDTO.self)
            .freeze()
            .map { (item) -> CardLocalDTO in
                item
            }
    }
    
    func observeCards() -> AnyPublisher<[CardLocalDTO], Never> {
        return self.cardsSubject.eraseToAnyPublisher()
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

//
//  CardRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
import Promises
import RxSwift

class CardRepo: CardRepoProtocol {
    
    private let localDataSource: CardLocalDataSourceProtocol
    private let remoteDataSource: CardRemoteDataSourceProtocol
    private let customerLocalDataSource: CustomerLocalDataSourceProtocol
    
    init(
        localDataSource: CardLocalDataSourceProtocol,
        remoteDataSource: CardRemoteDataSourceProtocol,
        customerLocalDataSource: CustomerLocalDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.customerLocalDataSource = customerLocalDataSource
    }
    
    func syncCards() -> Promise<Data> {
        self.remoteDataSource.getCards(by: customerLocalDataSource.getCustomerID())
            .then { data -> Promise<Data> in
                let localData = data.map { remote in
                    remote.toLocal()
                }
                
                return self.localDataSource.save(cards: localData)
            }
    }
    
    func observeCards() -> Observable<[Card]> {
        return self.localDataSource.observeCards()
            .map { localData in
                return localData.map { local in
                    local.toDomain()
                }
            }
    }
}

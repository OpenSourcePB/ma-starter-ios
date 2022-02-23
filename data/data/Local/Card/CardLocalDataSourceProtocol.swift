//
//  CardLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RxSwift
import Promises

protocol CardLocalDataSourceProtocol {
    func observeCards() -> Observable<[CardLocalDTO]>
    func save(cards: [CardLocalDTO]) -> Promise<Data>
}

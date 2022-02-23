//
//  CardRepoProtocol.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import RxSwift

public protocol CardRepoProtocol {
    func syncCards() -> Promise<Data>
    func observeCards() -> Observable<[Card]>
}

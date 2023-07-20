//
//  CardRepoProtocol.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import Combine

public protocol CardRepoProtocol {
    func syncCards() -> Promise<Data>
    func observeCards() -> AnyPublisher<[Card], Never>
}

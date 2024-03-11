//
//  CardLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

protocol CardLocalDataSourceProtocol {
    func observeCards() -> AnyPublisher<[CardLocalDTO], Never>
    func save(cards: [CardLocalDTO]) async throws
}

//
//  CardRepoProtocol.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

public protocol CardRepoProtocol {
    func syncCards() async throws
    func observeCards() -> AnyPublisher<[Card], Never>
}

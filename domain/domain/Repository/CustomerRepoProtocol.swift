//
//  CustomerRepoProtocol.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

public protocol CustomerRepoProtocol {
    func syncCustomer() async throws
    func observeCustomer() -> AnyPublisher<Customer, Never>
}

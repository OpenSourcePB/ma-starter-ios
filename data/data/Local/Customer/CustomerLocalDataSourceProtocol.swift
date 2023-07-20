//
//  CustomerLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

protocol CustomerLocalDataSourceProtocol {
    func getCustomerID() -> String
    func observeCustomer() -> AnyPublisher<CustomerLocalDTO?, Never>
    func save(customer: CustomerLocalDTO)
}

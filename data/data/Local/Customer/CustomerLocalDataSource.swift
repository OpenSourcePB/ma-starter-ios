//
//  CustomerLocalDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

class CustomerLocalDataSource:
    LocalDataStorage,
    CustomerLocalDataSourceProtocol {
    
    private let customerSubject: CurrentValueSubject<CustomerLocalDTO?, Never> = .init(nil)
    
    override init(logger: Logger) {
        super.init(logger: logger)
        self.customerSubject.send(self.getCached(key: LocalDataKeys.customer.rawValue))
    }
    
    func getCustomerID() -> String {
        return "1" // mock
    }
    
    func observeCustomer() -> AnyPublisher<CustomerLocalDTO?, Never> {
        self.customerSubject.eraseToAnyPublisher()
    }
    
    func save(customer: CustomerLocalDTO) {
        self.cache(key: LocalDataKeys.customer.rawValue, data: customer)
        self.customerSubject.send(customer)
    }
}

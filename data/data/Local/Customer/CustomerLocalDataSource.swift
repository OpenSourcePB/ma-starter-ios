//
//  CustomerLocalDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

class CustomerLocalDataSource: CustomerLocalDataSourceProtocol {

    private let localData: LocalDataStorage
    private let customerSubject: CurrentValueSubject<CustomerLocalDTO?, Never>
    
    init(localData: LocalDataStorage) {
        self.localData = localData
        self.customerSubject = .init(
            localData.getCached(key: LocalDataKeys.customer.rawValue)
        )
    }
    
    func getCustomerID() -> String {
        return "1" // mock
    }
    
    func observeCustomer() -> AnyPublisher<CustomerLocalDTO?, Never> {
        self.customerSubject.eraseToAnyPublisher()
    }
    
    func save(customer: CustomerLocalDTO) {
        self.localData.cache(key: LocalDataKeys.customer.rawValue, data: customer)
        self.customerSubject.send(customer)
    }
}

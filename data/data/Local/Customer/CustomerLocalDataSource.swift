//
//  CustomerLocalDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RxSwift
import RxRelay

class CustomerLocalDataSource:
    LocalDataStorage,
    CustomerLocalDataSourceProtocol {
    
    private let customerRelay: BehaviorRelay<CustomerLocalDTO?> = BehaviorRelay.init(value: nil)
    
    override init(logger: Logger) {
        super.init(logger: logger)
        
        self.customerRelay.accept(self.getCached(key: LocalDataKeys.customer.rawValue))
    }
    
    func getCustomerID() -> String {
        return "1" // mock
    }
    
    func observeCustomer() -> Observable<CustomerLocalDTO?> {
        return self.customerRelay.asObservable()
    }
    
    func save(customer: CustomerLocalDTO) {
        self.cache(key: LocalDataKeys.customer.rawValue, data: customer)
        self.customerRelay.accept(customer)
    }
}

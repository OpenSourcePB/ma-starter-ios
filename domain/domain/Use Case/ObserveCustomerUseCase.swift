//
//  ObserveCustomerUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

public class ObserveCustomerUseCase: BaseObservableUseCase {    
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Void) -> AnyPublisher<Customer, Never> {
        return self.repo.observeCustomer()
    }
}

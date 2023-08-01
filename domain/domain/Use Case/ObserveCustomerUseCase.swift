//
//  ObserveCustomerUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

public class ObserveCustomerUseCase: BaseObservableUseCase {
    typealias InputType = Data
    typealias OutputType = Customer
    
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Data) -> AnyPublisher<Customer, Never> {
        return self.repo.observeCustomer()
    }
}

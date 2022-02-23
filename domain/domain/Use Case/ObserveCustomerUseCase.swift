//
//  ObserveCustomerUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RxSwift

public class ObserveCustomerUseCase: BaseObservableUseCase {
    typealias InputType = Data
    typealias OutputType = Customer
    
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Data) -> Observable<Customer> {
        return self.repo.observeCustomer()
    }
}

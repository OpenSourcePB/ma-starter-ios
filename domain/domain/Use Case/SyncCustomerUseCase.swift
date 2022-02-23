//
//  SyncCustomerUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises

public class SyncCustomerUseCase: BasePromiseUseCase {
    typealias InputType = Data
    typealias OutputType = Data
    
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Data) -> Promise<Data> {
        return self.repo.syncCustomer()
    }
}

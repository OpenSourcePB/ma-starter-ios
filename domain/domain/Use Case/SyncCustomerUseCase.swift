//
//  SyncCustomerUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

public class SyncCustomerUseCase: BaseAsyncThrowsUseCase {
    private let repo: CustomerRepoProtocol
    
    init(repo: CustomerRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Void) async throws -> Void {
        try await self.repo.syncCustomer()
    }
}

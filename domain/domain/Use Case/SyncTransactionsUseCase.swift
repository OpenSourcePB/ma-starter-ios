//
//  SyncTransactionsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

public class SyncTransactionsUseCase: BaseAsyncThrowsUseCase {
    private let repo: TransactionRepoProtocol
    
    init(repo: TransactionRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Card) async throws -> Void {
        try await self.repo.syncTransactions(of: input)
    }
}

//
//  SyncTransactionsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises

public class SyncTransactionsUseCase: BasePromiseUseCase {
    typealias InputType = Card
    typealias OutputType = Data
    
    private let repo: TransactionRepoProtocol
    
    init(repo: TransactionRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Card) -> Promise<Data> {
        return self.repo.syncTransactions(of: input)
    }
}

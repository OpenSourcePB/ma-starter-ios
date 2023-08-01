//
//  ObserveTransactionsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

public class ObserveTransactionsUseCase: BaseObservableUseCase {
    typealias InputType = Card
    typealias OutputType = [Transaction]
    
    private let repo: TransactionRepoProtocol
    
    init(repo: TransactionRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Card) -> AnyPublisher<[Transaction], Never> {
        return self.repo.observeTransactions(of: input)
    }
}

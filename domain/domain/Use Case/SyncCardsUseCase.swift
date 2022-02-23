//
//  SyncCardsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises

public class SyncCardsUseCase: BasePromiseUseCase {
    typealias InputType = Data
    typealias OutputType = Data
    
    private let repo: CardRepoProtocol
    
    init(repo: CardRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Data) -> Promise<Data> {
        return self.repo.syncCards()
    }
}

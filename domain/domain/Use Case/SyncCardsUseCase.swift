//
//  SyncCardsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

public class SyncCardsUseCase: BaseAsyncThrowsUseCase {
    private let repo: CardRepoProtocol
    
    init(repo: CardRepoProtocol) {
        self.repo = repo
    }
    
    public func execute(input: Void) async throws -> Void{
        try await self.repo.syncCards()
    }
}

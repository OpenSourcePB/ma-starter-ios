//
//  ObserveCardsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Combine

public class ObserveCardsUseCase: BaseObservableUseCase {
    private let repo: CardRepoProtocol
    
    init(repo: CardRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Void) -> AnyPublisher<[Card], Never> {
        return self.repo.observeCards()
    }
}

//
//  ObserveCardsUseCase.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RxSwift

public class ObserveCardsUseCase: BaseObservableUseCase {
    typealias InputType = Data
    typealias OutputType = [Card]
    
    private let repo: CardRepoProtocol
    
    init(repo: CardRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(input: Data) -> Observable<[Card]> {
        return self.repo.observeCards()
    }
}

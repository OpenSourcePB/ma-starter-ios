//
//  DomainDI.swift
//  domain
//
//  Created by Karim Karimov on 28.02.21.
//

import Foundation
import Swinject

public class DomainAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: Container) {
        
        container.register(SyncCustomerUseCase.self) { r in
            SyncCustomerUseCase(repo: r.resolve(CustomerRepoProtocol.self)!)
        }
        
        container.register(ObserveCustomerUseCase.self) { r in
            ObserveCustomerUseCase(repo: r.resolve(CustomerRepoProtocol.self)!)
        }
        
        container.register(SyncCardsUseCase.self) { r in
            SyncCardsUseCase(repo: r.resolve(CardRepoProtocol.self)!)
        }
        
        container.register(ObserveCardsUseCase.self) { r in
            ObserveCardsUseCase(repo: r.resolve(CardRepoProtocol.self)!)
        }
        
        container.register(SyncTransactionsUseCase.self) { r in
            SyncTransactionsUseCase(repo: r.resolve(TransactionRepoProtocol.self)!)
        }
        
        container.register(ObserveTransactionsUseCase.self) { r in
            ObserveTransactionsUseCase(repo: r.resolve(TransactionRepoProtocol.self)!)
        }
    }
}

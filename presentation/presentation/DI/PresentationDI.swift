//
//  PresentationDI.swift
//  presentation
//
//  Created by Karim Karimov on 28.02.21.
//

import Foundation
import Swinject
import domain

public class PresentationAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: Container) {
        
        // MARK: - View models
        
        container.register(StartViewModel.self) { r in
            StartViewModel(
                localizationHelper: r.resolve(LocalizationHelper.self)!,
                syncCustomerUseCase: r.resolve(SyncCustomerUseCase.self)!,
                observeCustomerUseCase: r.resolve(ObserveCustomerUseCase.self)!,
                syncCardsUseCsase: r.resolve(SyncCardsUseCase.self)!,
                observeCardsUseCase: r.resolve(ObserveCardsUseCase.self)!,
                syncTransactionsUseCase: r.resolve(SyncTransactionsUseCase.self)!,
                observeTransactionsUseCase: r.resolve(ObserveTransactionsUseCase.self)!
            )
        }
        
        
        // MARK: - View controllers
        
        container.register(StartViewController.self) { r in
            StartViewController(
                navProvider: r.resolve(NavigationProviderProtocol.self)!,
                vm: r.resolve(StartViewModel.self)!)
        }
        
        // MARK: - View provider
        
        container.register(NavigationProviderProtocol.self) { r in
            NavigationProvider(resolver: r)
        }.inObjectScope(.container)
        
        // MARK: - Locale helper
        
        container.register(LocalizationHelper.self) { r in
            LocalizationHelper()
        }.inObjectScope(.container)
    }
}

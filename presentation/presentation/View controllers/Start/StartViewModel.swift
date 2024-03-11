//
//  StartViewModel.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import Foundation
import domain
import Combine

public class StartViewModel: BaseViewModel<Void, Void> {
    
    private let localizationHelper: LocalizationHelper
    private let syncCustomerUseCase: SyncCustomerUseCase
    private let observeCustomerUseCase: ObserveCustomerUseCase
    private let syncCardsUseCsase: SyncCardsUseCase
    private let observeCardsUseCase: ObserveCardsUseCase
    private let syncTransactionsUseCase: SyncTransactionsUseCase
    private let observeTransactionsUseCase: ObserveTransactionsUseCase

    private let customerDataSubject: CurrentValueSubject<Customer?, Never> = .init(nil)
    private let cardsDataSubject: CurrentValueSubject<[Card], Never> = .init([])
    private let activeCardSubject: CurrentValueSubject<Card?, Never> = .init(nil)
    private let transactionsSubject: CurrentValueSubject<[Transaction], Never> = .init([])
    
    private var cardTransactionSubscription: AnyCancellable? = nil
    
    init(localizationHelper: LocalizationHelper,
         syncCustomerUseCase: SyncCustomerUseCase,
         observeCustomerUseCase: ObserveCustomerUseCase,
         syncCardsUseCsase: SyncCardsUseCase,
         observeCardsUseCase: ObserveCardsUseCase,
         syncTransactionsUseCase: SyncTransactionsUseCase,
         observeTransactionsUseCase: ObserveTransactionsUseCase
    ) {
        self.localizationHelper = localizationHelper
        self.syncCustomerUseCase = syncCustomerUseCase
        self.observeCustomerUseCase = observeCustomerUseCase
        self.syncCardsUseCsase = syncCardsUseCsase
        self.observeCardsUseCase = observeCardsUseCase
        self.syncTransactionsUseCase = syncTransactionsUseCase
        self.observeTransactionsUseCase = observeTransactionsUseCase
        
        super.init()
        
        self.initLocalization()

        self.subscribeCustomer()
        self.subscribeCards()

        Task {
            await self.syncCustomerData()
            await self.syncCards()
        }
    }
    
    private func initLocalization() {
        self.localizationHelper.set(locale: "az-AZ")
    }
    
    private func syncCustomerData() async {
        do {
            try await self.syncCustomerUseCase.execute(input: Void())
            print("✅ Customer data is synced")
        } catch {
            self.show(error: error)
        }
    }
    
    private func syncCards() async {
        do {
            try await self.syncCardsUseCsase.execute(input: Void())
            print("✅ Cards are synced")
        } catch {
            self.show(error: error)
        }
    }
    
    private func subscribeCustomer() {
        let cancellable = self.observeCustomerUseCase.observe(input: Void())
            .sink { customer in
                self.customerDataSubject.send(customer)
            }
        self.add(cancellable: cancellable)
    }
    
    private func subscribeCards() {
        let cancellable = self.observeCardsUseCase.observe(input: Void())
            .sink { cards in
                self.cardsDataSubject.send(cards)

                if self.activeCardSubject.value == nil, let card = cards.first {
                    self.select(card: card)
                }
            }
        self.add(cancellable: cancellable)
    }
    
    func observeCustomer() -> AnyPublisher<Customer, Never> {
        self.customerDataSubject.compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func observeCards() -> AnyPublisher<[Card], Never> {
        self.cardsDataSubject.eraseToAnyPublisher()
    }
    
    func observeActiveCard() -> AnyPublisher<Card?, Never> {
        self.activeCardSubject.eraseToAnyPublisher()
    }
    
    func observeTransactions() -> AnyPublisher<[Transaction], Never> {
        return self.transactionsSubject.eraseToAnyPublisher()
    }
    
    func select(card: Card) {
        self.activeCardSubject.send(card)

        Task {
            do {
                try await self.syncTransactionsUseCase.execute(input: card)
                print("✅ Transactions of card (id: \(card.id)) are synced")
            } catch {
                self.show(error: error)
            }
        }

        self.cardTransactionSubscription?.cancel()

        self.cardTransactionSubscription = self.observeTransactionsUseCase.observe(input: card)
            .sink { transactions in
                self.transactionsSubject.send(transactions)
            }
        
        self.add(cancellable: self.cardTransactionSubscription!)
    }
    
    func getCards() -> [Card] {
        self.cardsDataSubject.value
    }
    
    func getTransactions() -> [Transaction] {
        self.transactionsSubject.value
    }
    
    func isCardSelected(card: Card) -> Bool {
        self.activeCardSubject.value?.id == card.id
    }
}

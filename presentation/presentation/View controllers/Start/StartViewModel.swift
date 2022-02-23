//
//  StartViewModel.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import Foundation
import domain
import Promises
import RxSwift
import RxRelay

public class StartViewModel: BaseViewModel<Void, Void> {
    
    private let localizationHelper: LocalizationHelper
    private let syncCustomerUseCase: SyncCustomerUseCase
    private let observeCustomerUseCase: ObserveCustomerUseCase
    private let syncCardsUseCsase: SyncCardsUseCase
    private let observeCardsUseCase: ObserveCardsUseCase
    private let syncTransactionsUseCase: SyncTransactionsUseCase
    private let observeTransactionsUseCase: ObserveTransactionsUseCase
    
    private let customerDataRelay: BehaviorRelay<Customer?> = BehaviorRelay.init(value: nil)
    private let cardsDataRelay: BehaviorRelay<[Card]> = BehaviorRelay.init(value: [])
    private let activeCardRelay: BehaviorRelay<Card?> = BehaviorRelay.init(value: nil)
    private let transactionsRelay: BehaviorRelay<[Transaction]> = BehaviorRelay.init(value: [])
    
    private var cardTransactionSubscription: Disposable? = nil
    
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
        self.syncCustomerData()
        self.syncCards()
        
        self.subscribeCustomer()
        self.subscribeCards()
    }
    
    private func initLocalization() {
        self.localizationHelper.set(locale: "az-AZ")
    }
    
    private func syncCustomerData() {
        self.syncCustomerUseCase.execute(input: Data())
            .then({ _ in
                print("✅ Customer data is synced")
            })
            .catch { error in
                self.show(error: error)
            }
    }
    
    private func syncCards() {
        self.syncCardsUseCsase.execute(input: Data())
            .then({ _ in
                print("✅ Cards are synced")
            })
            .catch { error in
                self.show(error: error)
            }
    }
    
    private func subscribeCustomer() {
        let subscription = self.observeCustomerUseCase.observe(input: Data())
            .subscribe { received in
                guard let data = received.element else { return }
                
                self.customerDataRelay.accept(data)
            }
        
        self.add(subscription: subscription)
    }
    
    private func subscribeCards() {
        let subscription = self.observeCardsUseCase.observe(input: Data())
            .subscribe { received in
                guard let data = received.element else { return }
                
                self.cardsDataRelay.accept(data)
                
                if self.activeCardRelay.value == nil, let card = data.first {
                    self.select(card: card)
                }
            }
        
        self.add(subscription: subscription)
    }
    
    func observeCustomer() -> Observable<Customer> {
        return self.customerDataRelay.asObservable()
            .filter { data in
                data != nil
            }
            .map { data in
                data!
            }
    }
    
    func observeCards() -> Observable<[Card]> {
        return self.cardsDataRelay.asObservable()
    }
    
    func observeActiveCard() -> Observable<Card?> {
        return self.activeCardRelay.asObservable()
    }
    
    func observeTransactions() -> Observable<[Transaction]> {
        return self.transactionsRelay.asObservable()
    }
    
    func select(card: Card) {
        self.activeCardRelay.accept(card)
        
        self.syncTransactionsUseCase.execute(input: card)
            .then({ _ in
                print("✅ Transactions of card (id: \(card.id)) are synced")
            })
            .catch { error in
                self.show(error: error)
            }
        
        self.cardTransactionSubscription?.dispose()
        
        self.cardTransactionSubscription = self.observeTransactionsUseCase.observe(input: card)
            .subscribe({ received in
                guard let data = received.element else { return }
                
                self.transactionsRelay.accept(data)
            })
        
        self.add(subscription: self.cardTransactionSubscription!)
    }
    
    func getCards() -> [Card] {
        return self.cardsDataRelay.value
    }
    
    func getTransactions() -> [Transaction] {
        return self.transactionsRelay.value
    }
    
    func isCardSelected(card: Card) -> Bool {
        return self.activeCardRelay.value?.id == card.id
    }
}

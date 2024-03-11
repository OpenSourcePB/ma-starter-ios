//
//  BaseViewModel.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import Foundation
import Combine


open class BaseViewModel<State, Effect> {
    
    private let isLoadingState: CurrentValueSubject<Bool, Never> = .init(false)
    
    private let stateSubject: CurrentValueSubject<State?, Never> = .init(nil)
    private let effectSubject: PassthroughSubject<Effect, Never> = .init()
    
    private let baseEffectSubject: PassthroughSubject<BaseEffect, Never> = .init()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    internal func setLoading(state: Bool) {
        self.isLoadingState.send(state)
    }
    
    internal func showLoading() {
        self.isLoadingState.send(true)
    }
    
    internal func hideLoading() {
        self.isLoadingState.send(false)
    }
    
    open func observeLoading() -> AnyPublisher<Bool, Never> {
        return self.isLoadingState.eraseToAnyPublisher()
    }
    
    internal func postEffect(effect: Effect) {
        self.effectSubject.send(effect)
    }
    
    internal func postBaseEffect(baseEffect: BaseEffect) {
        self.baseEffectSubject.send(baseEffect)
    }
    
    internal func postState(state: State) {
        self.stateSubject.send(state)
    }
    
    func observeEffect() -> AnyPublisher<Effect, Never> {
        return self.effectSubject.eraseToAnyPublisher()
    }
    
    func observeBaseEffect() -> AnyPublisher<BaseEffect, Never> {
        return self.baseEffectSubject.eraseToAnyPublisher()
    }
    
    func observeState() -> AnyPublisher<State, Never> {
        self.stateSubject.compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getState() -> State? {
        return self.stateSubject.value
    }
    
    func add(cancellable: AnyCancellable) {
        cancellable.store(in: &self.cancellables)
    }
    
    func show(error: Error) {
        self.postBaseEffect(baseEffect: .error(error))
    }
    
    func getConstant(key: String) -> String? {
        return Bundle(for: type(of: self)).infoDictionary![key] as? String
    }

    deinit {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
}

enum BaseEffect {
    case error(Error)
}

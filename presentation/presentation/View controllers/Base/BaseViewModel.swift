//
//  BaseViewModel.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import Foundation
import RxRelay
import RxSwift

open class BaseViewModel<State, Effect> {
    
    private let isLoadingState: BehaviorRelay<Bool> = BehaviorRelay<Bool>.init(value: false)
    
    private let stateRelay: BehaviorRelay<State?> = BehaviorRelay<State?>.init(value: nil)
    private let effectRelay: PublishRelay<Effect> = PublishRelay<Effect>.init()
    
    private let baseEffectRelay: PublishRelay<BaseEffect> = PublishRelay<BaseEffect>.init()
    
    private let disposeBag = DisposeBag()
    private let compositeDisposable = CompositeDisposable()
    
    init() {
        self.compositeDisposable.disposed(by: self.disposeBag)
    }
    
    internal func setLoading(state: Bool) {
        self.isLoadingState.accept(state)
    }
    
    internal func showLoading() {
        self.isLoadingState.accept(true)
    }
    
    internal func hideLoading() {
        self.isLoadingState.accept(false)
    }
    
    open func observeLoading() -> Observable<Bool> {
        return self.isLoadingState.asObservable()
    }
    
    internal func postEffect(effect: Effect) {
        self.effectRelay.accept(effect)
    }
    
    internal func postBaseEffect(baseEffect: BaseEffect) {
        self.baseEffectRelay.accept(baseEffect)
    }
    
    internal func postState(state: State) {
        self.stateRelay.accept(state)
    }
    
    func observeEffect() -> Observable<Effect> {
        return self.effectRelay.asObservable()
    }
    
    func observeBaseEffect() -> Observable<BaseEffect> {
        return self.baseEffectRelay.asObservable()
    }
    
    func observeState() -> Observable<State> {
        self.stateRelay
            .filter({ (optional) -> Bool in
                optional != nil
            })
            .map({ (optional) -> State in
                optional!
            })
            .asObservable()
    }
    
    func getState() -> State? {
        return self.stateRelay.value
    }
    
    func add(subscription: Disposable) {
        let _ = self.compositeDisposable.insert(subscription)
    }
    
    func show(error: Error) {
        self.postBaseEffect(baseEffect: .error(error))
    }
    
    func getConstant(key: String) -> String? {
        return Bundle(for: type(of: self)).infoDictionary![key] as? String
    }
}

enum BaseEffect {
    case error(Error)
}

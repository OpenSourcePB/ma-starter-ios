//
//  UIBaseViewController.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import UIKit
import RxSwift
import domain

open class UIBaseViewController<State, Effect, VM: BaseViewModel<State, Effect>>: UIViewController {

    // MARK: - Variables
    
    private var compositeDisposable = CompositeDisposable()
    internal var disposeBag = DisposeBag()
    
    var isPageInitialized = false
    
    private var progressView = ProgressView()
    
    internal let viewModel: VM
    var navProvider: NavigationProviderProtocol
    
    init(navProvider: NavigationProviderProtocol,
         vm: VM) {
        self.viewModel = vm
        self.navProvider = navProvider

        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller delegates
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
        self.initViews()
        self.initVars()
        self.isPageInitialized = true
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setText()
        
        self.compositeDisposable = CompositeDisposable()
        
        let baseEffectSubscription = self.viewModel.observeBaseEffect().subscribe { (received) in
            guard let effect = received.element else { return }
            
            self.observe(baseEffect: effect)
        }
        
        let effectSubscription = self.viewModel.observeEffect().subscribe { (received) in
            guard let effect = received.element else { return }
            
            self.observe(effect: effect)
        }
        
        let stateSubscription = self.viewModel.observeState().subscribe { (received) in
            guard let state = received.element else { return }
            
            self.observe(state: state)
        }
        
        let loadingSubscription = self.viewModel.observeLoading().subscribe { (received) in
            guard let isLoading = received.element else { return }
            
            if isLoading {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
        
        self.addSubscription(baseEffectSubscription)
        self.addSubscription(effectSubscription)
        self.addSubscription(stateSubscription)
        self.addSubscription(loadingSubscription)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.compositeDisposable.dispose()
    }
    
    // MARK: - Initializations
    
    func setText() {
        
    }
        
    // MARK: - Initializations
    
    func initVars() {
        self.compositeDisposable.disposed(by: self.disposeBag)
    }
    
    func initViews() {
        
    }
    
    // MARK: - Subscriptions
    
    func observe(effect: Effect) { }
    
    func observe(baseEffect: BaseEffect) {
        switch baseEffect {
        case .error(let error):
            let uiError = error as? UIError ?? UIError(type: .unknown)
            
            self.promptAlert(title: uiError.getTitle(),
                             content: uiError.getText(),
                             actionTitle: uiError.getActionBtn()) {
                
            }
        }
    }

    func observe(state: State) { }
    
    // MARK: - UI
    
    func addSubscription(_ subscription: Disposable) {
        let _ = self.compositeDisposable.insert(subscription)
    }
        
    func startAnimating() {
        self.progressView = ProgressView()
        addChild(self.progressView)
        self.progressView.view.frame = view.frame
        view.addSubview(self.progressView.view)
        self.progressView.didMove(toParent: self)
    }
    
    func stopAnimating() {
        self.progressView.willMove(toParent: nil)
        self.progressView.view.removeFromSuperview()
        self.progressView.removeFromParent()
    }
    
    func promptAlert(title: String,
                     content: String,
                     actionTitle: String,
                     onAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            
        let actionBtn = UIAlertAction(title: actionTitle, style: .default, handler: { action in
            onAction()
        })
        actionBtn.setValue(ColorName.mountainMeadow.color, forKey: "titleTextColor")

        alert.addAction(actionBtn)
        self.present(alert, animated: true)
    }
    
    func promptAlert(title: String,
                     content: String,
                     positiveActionTitle: String,
                     negativeActionTitle: String,
                     onPositiveAction: @escaping () -> Void,
                     onNegativeAction: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            
        let actionPositiveBtn = UIAlertAction(title: positiveActionTitle, style: .default, handler: { action in
            onPositiveAction()
        })
        actionPositiveBtn.setValue(ColorName.mountainMeadow.color, forKey: "titleTextColor")

        alert.addAction(actionPositiveBtn)
        
        let actionNegativeBtn = UIAlertAction(title: negativeActionTitle, style: .cancel, handler: { action in
            onNegativeAction()
        })
        actionNegativeBtn.setValue(ColorName.mountainMeadow.color, forKey: "titleTextColor")

        alert.addAction(actionNegativeBtn)
        
        alert.preferredAction = actionPositiveBtn
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    func pushNavigation(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearStack() {
        if let vcs = self.navigationController?.viewControllers {
            self.navigationController?.viewControllers.removeSubrange(0..<vcs.count-1)
        }
    }
}

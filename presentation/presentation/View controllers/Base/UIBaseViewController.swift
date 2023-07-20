//
//  UIBaseViewController.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import UIKit
import Combine
import domain

open class UIBaseViewController<State, Effect, VM: BaseViewModel<State, Effect>>: UIViewController {

    // MARK: - Variables
    
    private var cancellables: Set<AnyCancellable> = .init()
    
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

        let baseEffectSubscription = self.viewModel.observeBaseEffect().sink { effect in
            self.observe(baseEffect: effect)
        }
        
        let effectSubscription = self.viewModel.observeEffect().sink { effect in
            self.observe(effect: effect)
        }

        let stateSubscription = self.viewModel.observeState().sink { state in
            self.observe(state: state)
        }

        let loadingSubscription = self.viewModel.observeLoading().sink { isLoading in
            if isLoading {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }

        self.addCancellable(baseEffectSubscription)
        self.addCancellable(effectSubscription)
        self.addCancellable(stateSubscription)
        self.addCancellable(loadingSubscription)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
    
    // MARK: - Initializations
    
    func setText() {
        
    }
        
    // MARK: - Initializations
    
    func initVars() { }
    
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
    
    func addCancellable(_ cancellable: AnyCancellable) {
        cancellable.store(in: &self.cancellables)
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

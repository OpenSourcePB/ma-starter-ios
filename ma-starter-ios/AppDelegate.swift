//
//  AppDelegate.swift
//  ma-starter-ios
//
//  Created by Karim Karimov on 27.02.21.
//

import UIKit
import presentation
import domain
import data
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let assembler = Assembler([
            DomainAssembly(),
            DataAssembly(),
            PresentationAssembly()
        ])
        
        let startVC = assembler.resolver.resolve(StartViewController.self)!
        
        self.setupInitialPage(startVC)
        
        return true
    }
    
    private func setupInitialPage(_ vc: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
                
        let navigationController = UIBaseNavigationController(rootViewController: vc)
        navigationController.navigationBar.isHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

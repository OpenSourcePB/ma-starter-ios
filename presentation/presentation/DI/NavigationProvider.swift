//
//  ViewProvider.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import Foundation
import Swinject
 
protocol NavigationProviderProtocol {
    var startVC: StartViewController { get }
}

class NavigationProvider: NavigationProviderProtocol {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var startVC: StartViewController {
        get {
            resolver.resolve(StartViewController.self)!
        }
    }
}

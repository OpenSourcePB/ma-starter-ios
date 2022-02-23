//
//  LocalizationHelper.swift
//  presentation
//
//  Created by Karim Karimov on 22.03.21.
//

import Foundation
import domain

class LocalizationHelper {
    
    func set(locale: String) {
        L10n.bundle = Bundle(path: Bundle(for: type(of: self)).path(forResource: locale, ofType: "lproj")!)
                
        UserDefaults.standard.set([locale], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

//
//  ErrorTextMapper.swift
//  presentation
//
//  Created by Karim Karimov on 26.03.21.
//

import Foundation
import domain

extension UIError {

    func getText() -> String {
        var text = L10n.error
        
        switch self.type {
        default:
            text = L10n.error
        }
        
        return text
    }
    
    func getTitle() -> String {
        var text = L10n.error
        
        switch self.type {
        case .unknown:
            text = L10n.error
        }
        
        return text
    }
    
    func getActionBtn() -> String {
        var text = L10n.ok
        
        switch self.type {
        default:
            text = L10n.ok
        }
        
        return text
    }
}

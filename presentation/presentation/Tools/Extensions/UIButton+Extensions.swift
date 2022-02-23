//
//  UIButton+Extensions.swift
//  presentation
//
//  Created by Karim Karimov on 21.03.21.
//

import UIKit

extension UIButton {
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "AssociatedButtonClickGestureRecognizer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addClickListener(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        self.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
    }
    
    @objc fileprivate func handleClick(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        }
    }
}

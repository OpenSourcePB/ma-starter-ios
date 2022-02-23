//
//  UIBaseNavigationController.swift
//  presentation
//
//  Created by Karim Karimov on 18.03.21.
//

import UIKit

public class UIBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.isHidden = true
    }
}

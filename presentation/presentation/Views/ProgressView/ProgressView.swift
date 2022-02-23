//
//  ProgressView.swift
//  presentation
//
//  Created by Karim Karimov on 22.02.22.
//

import UIKit
import SnapKit

class ProgressView: UIViewController {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            view.style = UIActivityIndicatorView.Style.medium
        }
        
        view.color = .white
        
        return view
    }()
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        self.view.addSubview(indicator)
                
        self.indicator.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        self.indicator.startAnimating()
    }
}

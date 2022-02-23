//
//  UIError.swift
//  domain
//
//  Created by Karim Karimov on 25.03.21.
//

import Foundation

public class UIError: Error {
    
    public let type: UIErrorType
    
    public init(type: UIErrorType) {
        self.type = type
    }
}

public enum UIErrorType: String {
    case unknown = ""
}

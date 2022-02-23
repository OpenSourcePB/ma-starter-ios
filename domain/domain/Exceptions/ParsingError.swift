//
//  ParsingError.swift
//  domain
//
//  Created by Karim Karimov on 01.03.21.
//

import Foundation

public class ParsingError: Error {
    
    public let description: String
    
    public init(description: String) {
        self.description = description
    }
}

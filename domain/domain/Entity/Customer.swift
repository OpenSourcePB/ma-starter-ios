//
//  Customer.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

public struct Customer {
    public let id: String
    public let name: String
    public let phone: String
    
    public init(
        id: String,
        name: String,
        phone: String
    ) {
        self.id = id
        self.name = name
        self.phone = phone
    }
}

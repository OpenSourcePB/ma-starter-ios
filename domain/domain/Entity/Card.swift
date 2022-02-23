//
//  Card.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

public struct Card {
    public let id: String
    public let pan: String
    public let balance: Double
    public let currency: String
    public let type: ECardType
    public let status: ECardStatus
    
    public init(
        id: String,
        pan: String,
        balance: Double,
        currency: String,
        type: ECardType,
        status: ECardStatus
    ) {
        self.id = id
        self.pan = pan
        self.balance = balance
        self.currency = currency
        self.type = type
        self.status = status
    }
}

//
//  Transaction.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

public struct Transaction {
    public let id: String
    public let amount: Double
    public let title: String
    public let datetime: Date
    public let currency: String
    public let category: ETransactionCategory
    
    public init(
        id: String,
        amount: Double,
        title: String,
        datetime: Date,
        currency: String,
        category: ETransactionCategory
    ) {
        self.id = id
        self.amount = amount
        self.title = title
        self.datetime = datetime
        self.currency = currency
        self.category = category
    }
}

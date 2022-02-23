//
//  TransactionAPI.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

struct TransactionAPI {
    static func getTransactions(of customerId: String, of cardId: String) -> String {
        return "/customers/\(customerId)/cards/\(cardId)/transactions"
    }
}

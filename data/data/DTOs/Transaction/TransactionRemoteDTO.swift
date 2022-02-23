//
//  TransactionRemoteDTO.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

struct TransactionRemoteDTO: Codable {
    let id: String
    let category: String
    let title: String
    let amount: String
    let createdAt: String
    let currency: String
}

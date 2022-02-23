//
//  CardRemoteDTO.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

struct CardRemoteDTO: Codable {
    let id: String
    let createdAt: String
    let pan: String
    let balance: String
    let type: String
    let status: String
    let currency: String
    let customerId: String
}


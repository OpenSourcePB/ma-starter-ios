//
//  CardAPI.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

struct CardAPI {
    static func getCards(of customerId: String) -> String {
        return "/customers/\(customerId)/cards"
    }
}

//
//  CustomerAPI.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

struct CustomerAPI {
    static func getCustomer(by id: String) -> String {
        return "/customers/\(id)"
    }
}

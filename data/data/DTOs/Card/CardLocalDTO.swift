//
//  CardLocalDTO.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RealmSwift

class CardLocalDTO: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var pan: String = ""
    @objc dynamic var balance: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var status: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setData(
        id: String,
        pan: String,
        balance: String,
        currency: String,
        type: String,
        status: String)
    {
        self.id = id
        self.pan = pan
        self.balance = balance
        self.currency = currency
        self.type = type
        self.status = status
    }
}

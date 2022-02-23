//
//  TransactionLocalDTO.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RealmSwift

class TransactionLocalDTO: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var cardId: String = ""
    @objc dynamic var amount: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var datetime: String = ""
    @objc dynamic var category: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setData(
        id: String,
        cardId: String,
        amount: String,
        title: String,
        currency: String,
        datetime: String,
        category: String)
    {
        self.id = id
        self.cardId = cardId
        self.amount = amount
        self.title = title
        self.currency = currency
        self.datetime = datetime
        self.category = category
    }
}


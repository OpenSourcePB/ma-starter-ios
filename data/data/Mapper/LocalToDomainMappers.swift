//
//  LocalToDomainMappers.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain

extension CustomerLocalDTO {
    func toDomain() -> Customer {
        return Customer(
            id: self.id,
            name: self.name,
            phone: self.phone
        )
    }
}

extension CardLocalDTO {
    func toDomain() -> Card {
        return Card(
            id: self.id,
            pan: self.pan,
            balance: Double(self.balance) ?? 0.0,
            currency: self.currency,
            type: self.getCardType(),
            status: self.getCardStatus()
        )
    }
    
    func getCardType() -> ECardType {
        switch self.type {
        case "visa":
            return .visa
        case "master":
            return .master
        case "union_pay":
            return .union_pay
        default:
            return .unknown
        }
    }
    
    func getCardStatus() -> ECardStatus {
        switch self.status {
        case "active":
            return .active
        case "blocked":
            return .blocked
        case "expired":
            return .expired
        default:
            return .blocked
        }
    }
}

extension TransactionLocalDTO {
    func toDomain() -> Transaction {
        return Transaction(
            id: self.id,
            amount: Double(self.amount) ?? 0.0,
            title: self.title,
            datetime: self.datetime.formatDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") ?? Date(),
            currency: self.currency,
            category: self.getCategory())
    }
    
    func getCategory() -> ETransactionCategory {
        switch self.category {
        case "fuel":
            return .fuel
        case "grocery":
            return .grocery
        case "health":
            return .health
        default:
            return .other
        }
    }
}

extension String {
    
    func formatDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}

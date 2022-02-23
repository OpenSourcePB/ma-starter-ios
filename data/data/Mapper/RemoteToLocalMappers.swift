//
//  RemoteToLocalMappers.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

extension CustomerRemoteDTO {
    func toLocal() -> CustomerLocalDTO {
        return CustomerLocalDTO(
            id: self.id,
            name: self.name,
            phone: self.phone)
    }
}

extension CardRemoteDTO {
    func toLocal() -> CardLocalDTO {
        let data = CardLocalDTO()
        data.setData(
            id: self.id,
            pan: self.pan,
            balance: self.balance,
            currency: self.currency,
            type: self.type,
            status: self.status
        )
        return data
    }
}

extension TransactionRemoteDTO {
    func toLocal(cardId: String) -> TransactionLocalDTO {
        let data = TransactionLocalDTO()
        data.setData(
            id: self.id,
            cardId: cardId,
            amount: self.amount,
            title: self.title,
            currency: self.currency,
            datetime: self.createdAt,
            category: self.category)
        return data
    }
}

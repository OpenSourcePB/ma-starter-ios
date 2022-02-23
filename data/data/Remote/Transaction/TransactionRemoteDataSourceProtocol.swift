//
//  TransactionRemoteDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises

protocol TransactionRemoteDataSourceProtocol {
    func getTransactions(of customerId: String, of cardId: String) -> Promise<[TransactionRemoteDTO]>
}

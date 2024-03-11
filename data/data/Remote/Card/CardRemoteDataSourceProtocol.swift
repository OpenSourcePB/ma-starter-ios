//
//  CardRemoteDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

protocol CardRemoteDataSourceProtocol {
    func getCards(by customerId: String) async throws -> [CardRemoteDTO]
}


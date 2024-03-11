//
//  CustomerRemoteDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Alamofire

class CustomerRemoteDataSource: CustomerRemoteDataSourceProtocol {
    
    private let networkClient: AsyncNetworkClientProtocol
    
    init(networkClient: AsyncNetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getCustomer(by id: String) async throws -> CustomerRemoteDTO {
        try await self.networkClient.request(
            url: CustomerAPI.getCustomer(by: id),
            method: .get,
            headers: .default,
            params: EmptyParams(),
            encoder: URLEncodedFormParameterEncoder.default
        )
    }
}

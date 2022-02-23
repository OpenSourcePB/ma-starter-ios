//
//  CustomerRemoteDataSource.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import Alamofire

class CustomerRemoteDataSource: CustomerRemoteDataSourceProtocol {
    
    private let networkClient: NetworkClientProvider
    
    init(networkClient: NetworkClientProvider) {
        self.networkClient = networkClient
    }
    
    func getCustomer(by id: String) -> Promise<CustomerRemoteDTO> {
        self.networkClient.request(
            url: CustomerAPI.getCustomer(by: id),
            method: .get,
            params: EmptyParams()
        )
    }
}

//
//  CustomerRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
import Promises
import Combine

class CustomerRepo: CustomerRepoProtocol {
    
    private let localDataSource: CustomerLocalDataSourceProtocol
    private let remoteDataSource: CustomerRemoteDataSourceProtocol
    
    init(
        localDataSource: CustomerLocalDataSourceProtocol,
        remoteDataSource: CustomerRemoteDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func syncCustomer() -> Promise<Data> {
        self.remoteDataSource.getCustomer(by: self.localDataSource.getCustomerID())
            .then { data -> Promise<Data> in
                self.localDataSource.save(customer: data.toLocal())
                
                return Promise<Data>() {
                    return Data()
                }
            }
    }
    
    func observeCustomer() -> AnyPublisher<Customer, Never> {
        self.localDataSource.observeCustomer()
            .compactMap { $0 }
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}

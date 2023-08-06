//
//  CustomerRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
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
    
    func syncCustomer() async throws {
        let customer = try await self.remoteDataSource.getCustomer(
            by: self.localDataSource.getCustomerID()
        ).toLocal()

        self.localDataSource.save(customer: customer)
    }
    
    func observeCustomer() -> AnyPublisher<Customer, Never> {
        self.localDataSource.observeCustomer()
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}

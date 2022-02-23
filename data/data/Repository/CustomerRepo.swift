//
//  CustomerRepo.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import domain
import Promises
import RxSwift

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
    
    func observeCustomer() -> Observable<Customer> {
        return self.localDataSource.observeCustomer()
            .filter({ local in
                local != nil
            })
            .map { local in
                local!.toDomain()
            }
    }
}

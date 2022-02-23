//
//  CustomerRemoteDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises

protocol CustomerRemoteDataSourceProtocol {
    func getCustomer(by id: String) -> Promise<CustomerRemoteDTO>
}

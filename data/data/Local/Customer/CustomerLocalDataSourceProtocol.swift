//
//  CustomerLocalDataSourceProtocol.swift
//  data
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import RxSwift

protocol CustomerLocalDataSourceProtocol {
    func getCustomerID() -> String
    func observeCustomer() -> Observable<CustomerLocalDTO?>
    func save(customer: CustomerLocalDTO)
}

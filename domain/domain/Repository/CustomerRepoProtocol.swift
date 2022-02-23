//
//  CustomerRepoProtocol.swift
//  domain
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation
import Promises
import RxSwift

public protocol CustomerRepoProtocol {
    func syncCustomer() -> Promise<Data>
    func observeCustomer() -> Observable<Customer>
}

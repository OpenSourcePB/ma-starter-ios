//
//  BasePromiseUseCase.swift
//  domain
//
//  Created by Karim Karimov on 25.03.21.
//

import Foundation
import Promises

protocol BasePromiseUseCase {
    associatedtype InputType
    
    associatedtype OutputType
    
    func execute(input: InputType) -> Promise<OutputType>
}

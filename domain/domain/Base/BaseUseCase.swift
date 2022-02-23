//
//  BaseUseCase.swift
//  domain
//
//  Created by Karim Karimov on 28.02.21.
//

import Foundation

protocol BaseUseCase {
    associatedtype InputType
    
    associatedtype OutputType
    
    func execute(input: InputType) -> OutputType
}

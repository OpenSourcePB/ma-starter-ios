//
//  BaseObservableUseCase.swift
//  domain
//
//  Created by Karim Karimov on 22.03.21.
//

import Foundation
import RxSwift

protocol BaseObservableUseCase {
    associatedtype InputType
    
    associatedtype OutputType
    
    func observe(input: InputType) -> Observable<OutputType>
}

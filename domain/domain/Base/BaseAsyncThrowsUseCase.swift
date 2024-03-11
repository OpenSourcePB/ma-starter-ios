//
//  BaseAsyncThrowsUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 04.08.23.
//

import Foundation

protocol BaseAsyncThrowsUseCase {
    associatedtype InputType

    associatedtype OutputType

    func execute(input: InputType) async throws -> OutputType
}

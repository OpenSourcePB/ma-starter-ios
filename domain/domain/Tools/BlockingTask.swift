//
//  BlockingTask.swift
//  domain
//
//  Created by Rza Ismayilov on 04.08.23.
//

import Foundation

fileprivate class BlockingTask<T, E: Error> {
    private let semaphore = DispatchSemaphore(value: 0)
    private var result: Result<T, E>?

    init(block: @escaping () async -> T) where E == Never {
        Task {
            self.result = .success(await block())
            self.semaphore.signal()
        }
    }

    init(block: @escaping () async throws -> T) where E == Error {
        Task {
            do {
                self.result = .success(try await block())
            } catch {
                self.result = .failure(error)
            }
            self.semaphore.signal()
        }
    }

    func wait() -> T where E == Never {
        if let result { return try! result.get() }
        self.semaphore.wait()
        return try! self.result!.get()
    }

    func wait() -> Result<T, E> {
        if let result { return result }
        self.semaphore.wait()
        return self.result!
    }

    func wait() throws -> T {
        if let result { return try result.get() }
        self.semaphore.wait()
        return try self.result!.get()
    }
}

public func runBlocking<T>(block: @escaping () async -> T) -> T {
    BlockingTask(block: block).wait()
}

public func runBlocking<T>(block: @escaping () async throws -> T) -> Result<T, Error> {
    BlockingTask(block: block).wait()
}

public func runBlocking<T>(block: @escaping () async throws -> T) throws -> T {
    try BlockingTask(block: block).wait()
}


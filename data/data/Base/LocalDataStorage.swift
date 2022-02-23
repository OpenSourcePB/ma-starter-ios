//
//  LocalDataStorage.swift
//  data
//
//  Created by Karim Karimov on 01.03.21.
//

import Foundation
import Promises
import domain

open class LocalDataStorage {
    
    // MARK: - Variables
    
    private let userDefaults: UserDefaults
    
    let logger: Logger
    
    // MARK: - Constructor
    
    init(logger: Logger) {
        self.userDefaults = UserDefaults.standard
        self.logger = logger
    }
    
    // MARK: - Functions
    
    func cache<T: Encodable>(key: String, data: T) {
        if let encoded = try? JSONEncoder().encode(data) {
            self.userDefaults.set(encoded, forKey: key)
        } else {
            logger.logDebug("Not saved \(T.self)")
        }
    }
    
    func cache(key: String, value: String) {
        self.userDefaults.set(value, forKey: key)
    }
    
    func cache(key: String, value: Int) {
        self.userDefaults.set(value, forKey: key)
    }
    
    func getCached<T: Decodable>(key: String) -> T? {
        if let data = self.userDefaults.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        
        return nil
    }
    
    func getCachedString(key: String) -> String? {
        return self.userDefaults.string(forKey: key)
    }
    
    func getCachedInt(key: String) -> Int? {
        return self.userDefaults.integer(forKey: key)
    }
    
    func getCachedDouble(key: String) -> Double? {
        return self.userDefaults.double(forKey: key)
    }
    
    func removeCachedValue(key: String) {
        self.userDefaults.removeObject(forKey: key)
    }
}

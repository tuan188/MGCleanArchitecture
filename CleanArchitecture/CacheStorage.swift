//
//  CacheStorage.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 10/25/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

@propertyWrapper
struct CacheStorage<T: Codable & Equatable> {
    private let key: String
    private let defaultValue: T
    private var cachedValue: T?
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        mutating get {
            if let value = cachedValue {
                return value
            }
            
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            cachedValue = value
            
            return value ?? defaultValue
        }
        set {
            guard newValue != cachedValue else { return }
            
            cachedValue = newValue
            
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

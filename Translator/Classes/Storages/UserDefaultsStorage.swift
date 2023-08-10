//
//  UserDefaultsStorage.swift
//  Translator
//
//  Created by Kyrylo Chernov on 04.08.2023.
//

import Foundation

enum LocalKey: String {
    case isFirstOpen
    case originalLanguage
    case translatedLanguage
    case history
    case countOfClosePremium
    case countOfOpens
}

class UserDefaultsStorage {
    
    static let shared = UserDefaultsStorage()
    
    private let storage = UserDefaults.standard
    
    func set<T>(key: LocalKey, value: T) where T : Codable {
        storage.set(try? JSONEncoder().encode(value), forKey: key.rawValue)
    }
    
    func add<T>(key: LocalKey, value: T) where T : Codable & Equatable {
        guard var array: [T] = get(key: key) else {
            set(key: key, value: [value])
            return
        }
        array.removeAll(where: { $0 == value })
        array.append(value)
        set(key: key, value: array)
    }
    
    func replace<T>(key: LocalKey, value: T) where T: Codable, T: Equatable {
        guard var array: [T] = get(key: key) else {
            return
        }
        guard let index = array.firstIndex(of: value) else { return }
        array[index] = value
        
        set(key: key, value: array)
    }
 
    func remove<T>(key: LocalKey, value: T) where T : Codable, T : Equatable {
        guard var array: [T] = get(key: key) else {
            return
        }
        array.removeAll(where: {value == $0} )
        set(key: key, value: array)
    }
    
    func get<T>(key: LocalKey) -> T? where T : Decodable {
        guard let data = storage.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func get<T>(key: LocalKey, defaultValue: T) -> T where T : Decodable {
        guard let data = storage.object(forKey: key.rawValue) as? Data else { return defaultValue }
        return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }
    
    func clear(key: LocalKey) {
        storage.setValue(nil, forKey: key.rawValue)
    }
}

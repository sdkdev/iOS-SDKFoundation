//
//  UserDefaultsKeyValueStore.swift
//  HMGPersistence
//
//  Created by Codex on 18.02.26.
//

import Foundation

public struct UserDefaultsKeyValueStore: HMGKeyValueStore {
    let userDefaults: UserDefaults
    public typealias StoreError = HMGKeyValueStoreError

    public init(
        userDefaults: UserDefaults = .standard,
    ) {
        self.userDefaults = userDefaults
    }

    public func getValue<T: Codable>(forKey key: String) throws(StoreError) -> T {
        guard let data = userDefaults.data(forKey: key) else {
            throw StoreError.notFound
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw StoreError.decodingFailed
        }
    }

    public func set<T: Codable>(_ value: T, forKey key: String) throws(StoreError) {
        let data: Data
        do {
            data = try JSONEncoder().encode(value)
        } catch {
            throw StoreError.encodingFailed
        }
        userDefaults.set(data, forKey: key)
    }

    public func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

    public func containsValue(forKey key: String) -> Bool {
        return userDefaults.data(forKey: key) != nil
    }
}

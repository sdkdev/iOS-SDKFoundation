//
//  HMGKeyValueStore.swift
//  HMGPersistence
//
//  Created by Sascha Kratochvil on 09.09.25.
//

import Foundation

/// Typed failures returned by ``HMGKeyValueStore`` operations.
public enum HMGKeyValueStoreError: Error, Equatable {
    /// No value exists for the requested key.
    case notFound
    /// Stored bytes could not be decoded to the requested type.
    case decodingFailed
    /// The provided value could not be encoded for storage.
    case encodingFailed
}

/// A lightweight, type-safe interface for key-value persistence.
///
/// Conform to `HMGKeyValueStore` to provide a storage backend (for example,
/// `UserDefaults`, a file-backed store, or an in-memory dictionary) that can
/// read and write `Codable` values by string keys.
///
/// Typical usage:
/// - Use `set(_:forKey:)` to persist any `Codable` value.
/// - Use `getValue(forKey:)` to retrieve and decode a previously stored value.
/// - Use `containsValue(forKey:)` to check for the existence of a value without decoding it.
/// - Use `removeValue(forKey:)` to delete a value.
///
/// Thread-safety and lifetime semantics are determined by the conforming type.
///
/// Errors:
/// - `getValue(forKey:)` and `set(_:forKey:)` are `throws` to allow conformers to surface
///   encoding/decoding failures, I/O failures, or other storage errors.
///
/// Type constraints:
/// - All stored and retrieved values must conform to `Codable`.
///
/// Keys:
/// - Keys are case-sensitive strings and their namespace is defined by the conformer.
///   Avoid collisions by using well-scoped, unique key names.
///
/// Example considerations for conformers:
/// - Decide how to map keys to storage locations (e.g., user defaults suite, file paths).
/// - Define error types that explain failures (e.g., not found, decoding failed).
/// - Document whether `getValue(forKey:)` throws when a key is missing or returns a default.
/// - Clarify whether operations are synchronous or asynchronous and whether they are thread-safe.
public protocol HMGKeyValueStore {
    /// Returns a decoded value for the provided key.
    ///
    /// - Parameter key: The lookup key.
    /// - Returns: The decoded value as `T`.
    /// - Throws: ``HMGKeyValueStoreError/notFound`` when no value exists,
    ///   or ``HMGKeyValueStoreError/decodingFailed`` when decoding fails.
    func getValue<T: Codable>(forKey key: String) throws(HMGKeyValueStoreError) -> T

    /// Persists a value under the provided key.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The lookup key.
    /// - Throws: ``HMGKeyValueStoreError/encodingFailed`` when encoding fails.
    func set<T: Codable>(_ value: T, forKey key: String) throws(HMGKeyValueStoreError)

    /// Removes a stored value for the provided key.
    ///
    /// If no value exists, implementations may treat this as a no-op.
    ///
    /// - Parameter key: The key to remove.
    func removeValue(forKey key: String)

    /// Returns whether a value currently exists for the provided key.
    ///
    /// - Parameter key: The lookup key.
    /// - Returns: `true` if a value exists, otherwise `false`.
    func containsValue(forKey key: String) -> Bool

}

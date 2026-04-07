//
//  HMGPersistenceTests.swift
//  HMGPersistence
//
//  Created by Sascha Kratochvil on 09.09.25.
//

import Foundation
@testable import SDKFoundation
import Testing

struct UserDefaultsKeyValueStoreTest {

    @Test
    func init_injectUserDefaults_useInjectedUserDefaults() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)

            #expect(sut.userDefaults == userDefaults)
        }
    }

    @Test
    func set_validValue_storesDataForKey() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)

            let value = TestProfile(id: UUID(), name: "Sascha")

            try sut.set(value, forKey: "profile")

            #expect(userDefaults.data(forKey: "profile") != nil)
        }
    }

    @Test
    func get_existingValue_returnsDecodedValue() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)
            let expected = TestProfile(id: UUID(), name: "Sascha")

            try sut.set(expected, forKey: "profile")
            let loaded: TestProfile = try sut.getValue(forKey: "profile")

            #expect(loaded == expected)
        }
    }

    @Test
    func get_missingValue_throwsNotFound() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)

            #expect(throws: UserDefaultsKeyValueStore.StoreError.notFound) {
                let _: TestProfile = try sut.getValue(forKey: "missing_profile")
            }
        }
    }

    @Test
    func containsValue_existingKey_returnsTrue() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)
            let value = TestProfile(id: UUID(), name: "Sascha")

            try sut.set(value, forKey: "profile")

            #expect(sut.containsValue(forKey: "profile"))
        }
    }

    @Test
    func containsValue_missingKey_returnsFalse() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)

            #expect(sut.containsValue(forKey: "profile") == false)
        }
    }

    @Test
    func removeValue_existingKey_removesStoredValue() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)
            let value = TestProfile(id: UUID(), name: "Sascha")

            try sut.set(value, forKey: "profile")
            #expect(sut.containsValue(forKey: "profile"))

            sut.removeValue(forKey: "profile")

            #expect(sut.containsValue(forKey: "profile") == false)
        }
    }

    @Test
    func removeValue_missingKey_isNoOperation() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)

            sut.removeValue(forKey: "missing_profile")

            #expect(!sut.containsValue(forKey: "missing_profile"))
        }
    }

    @Test
    func get_decodeFailure_throwsDecodingFailed() throws {
        try withIsolatedUserDefaults(testName: #function) { userDefaults in
            let sut = UserDefaultsKeyValueStore(userDefaults: userDefaults)
            userDefaults.set(Data([0xFF, 0x00, 0xAA]), forKey: "profile")

            #expect(throws: UserDefaultsKeyValueStore.StoreError.decodingFailed) {
                let _: TestProfile = try sut.getValue(forKey: "profile")
            }
        }
    }

    // MARK: - Helper

    private struct TestProfile: Codable, Equatable {
        let id: UUID
        let name: String
    }

    private func withIsolatedUserDefaults(
        testName: String,
        _ body: (UserDefaults) throws -> Void,
    ) throws {
        let suiteName = "UserDefaultsKeyValueStoreTest.\(testName)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }
        try body(userDefaults)
    }

}

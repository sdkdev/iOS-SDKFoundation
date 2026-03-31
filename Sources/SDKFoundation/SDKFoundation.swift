// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct User: Codable {
    let firstName: String
    let lastName: String
    
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

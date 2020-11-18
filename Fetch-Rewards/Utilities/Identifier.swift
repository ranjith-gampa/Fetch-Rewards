//
//  Identifier.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Foundation

/// A generic type that can be used to create distinct, strongly-typed identifiers
///
/// Example:
/// ```
/// struct User: {
///   var id: Identifier<Self>
/// }
/// let user = User(id: "new-user")
/// print(user.identifier) // "new-user"
/// ```
///
/// Based on https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/

public struct Identifier<T>: Hashable, Codable {
    var value: Int
}

extension Identifier: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int.IntegerLiteralType) {
        self.value = value
    }
}

extension Identifier: CustomStringConvertible {
    public var description: String {
        return value.description
    }
}

//
//  Identifiers.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Foundation

public enum ItemGroup {
    /// A strongly typed identifier for `id` of  a ItemGroup
    public typealias ID = Identifier<Self>
}

public enum Item {
    /// A strongly typed identifier for `id` of an item
    public typealias ID = Identifier<Self>
}

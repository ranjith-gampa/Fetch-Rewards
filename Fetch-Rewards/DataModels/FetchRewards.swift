//
//  FetchRewards.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Foundation

struct FetchRewards {
    var rewards: [Reward]
    
    struct Reward {
        var itemId: Item.ID
        var groupId: ItemGroup.ID
        var name: String?
    }

    init(rewards: [Reward]) {
        self.rewards = rewards
    }
}

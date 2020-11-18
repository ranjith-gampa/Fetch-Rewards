//
//  RewardsPresentation.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Foundation

extension RewardsViewController.Model {
    init(from state: RewardsDataSource.State) {
        switch state {
        case .ready:
            // TODO:
            print("Ready state")
        case .loading:
            self.isLoading = true
        case .loaded(let rewards):
            self.isLoading = false
            self.groups = getGroups(from: rewards)
        case .error: // TODO:
            self.isLoading = false
            self.didFail = true
            print("Error state")
        }
    }
    
    func getGroups(from rewards: FetchRewards) -> [ViewItemGroup] {
        var groupsDict = [ItemGroup.ID: ViewItemGroup]()
        rewards.rewards.forEach { reward in
            if let group = groupsDict[reward.groupId] {
                var items = group.items
                items.append(.init(from: reward))
                groupsDict[reward.groupId] = .init(id: reward.groupId, items: items)
            } else {
                var items = [ViewItemGroup.ViewItem]()
                items.append(.init(from: reward))
                groupsDict[reward.groupId] = .init(id: reward.groupId, items: items)
            }
        }
        
        groupsDict.forEach {
            let sortedItems = $1.items.sorted(by: { $0.id.value < $1.id.value })
            
            groupsDict[$1.id] = .init(id: $1.id, items: sortedItems)
        }
        
        return groupsDict.sorted(by: { $0.key.value < $1.key.value }).compactMap({ $0.value })
    }
}

extension RewardsViewController.Model.ViewItemGroup.ViewItem {
    init(from reward: FetchRewards.Reward) {
        self.id = reward.itemId
        self.name = reward.name
    }
}



extension ItemTableViewCell.Model {
    init?(from item: RewardsViewController.Model.ViewItemGroup.ViewItem?) {
        guard let item = item else { return nil }
        
        self.name = item.name
    }
}

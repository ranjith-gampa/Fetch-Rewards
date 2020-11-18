//
//  RewardsDataSource.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Foundation

class RewardsDataSource {
    private var networking: RewardsNetworking
    
    @Published
    var state: State = .ready
    
    enum State {
        case ready
        case loading
        case loaded(FetchRewards)
        case error
    }
    
    init(networking: RewardsNetworking) {
        self.networking = networking
    }
    
    func loadItems() {
        networking.loadItems()
    }
}

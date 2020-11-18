//
//  RewardsDataSource.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Combine
import Foundation

class RewardsDataSource {
    private var networking: RewardsNetworking
    
    @Published
    var state: State = .ready
    
    private var task: AnyCancellable?

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
        self.state = .loading
        task = networking.loadItems()
            .subscribe(on: DispatchQueue.main)
            .map { $0 }
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure: self?.state = .error
                case .finished: break
                }
            }, receiveValue: { [weak self] rewards in
                self?.state = .loaded(rewards)
            })
    }
}

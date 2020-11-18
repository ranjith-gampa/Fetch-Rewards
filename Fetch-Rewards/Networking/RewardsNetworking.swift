//
//  RewardsNetworking.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import Combine
import Foundation

class RewardsNetworking {
    
    // TODO: Use service
    private var url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json")!
    private var queue = DispatchQueue(label: "Fetch-Rewards-Queue")
    private var subscriptions = Set<AnyCancellable>()

    private let urlSession = URLSession(configuration: .default)

    func loadItems() -> AnyPublisher<FetchRewards, Error> {
        return urlSession.dataTaskPublisher(for: url)
            .subscribe(on: queue)
            .receive(on: queue)
            .tryMap {
                guard $0.data.count > 0 else { throw URLError(.zeroByteResource) }
                return $0.data
            }
            .decode(type: [_Reward].self, decoder: JSONDecoder())
            .map { response in
                let fetchResponse = FetchRewards(rewards: response.map { .init(from: $0) })

                return fetchResponse
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}

struct _Reward: Decodable {
    var id: Int
    var listId: Int
    var name: String?
}

extension FetchRewards.Reward {
    init(from response: _Reward) {
        self.itemId = .init(value: response.id)
        self.groupId = .init(value: response.listId)
        self.name = response.name
    }
}

extension FetchRewards {
    init(data: Data) throws {
        let decoded = try JSONDecoder().decode([_Reward].self, from: data)
        
        rewards = decoded.map { .init(from: $0) }
    }
}

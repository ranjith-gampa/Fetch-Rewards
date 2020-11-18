//
//  AppDelegate.swift
//  Fetch-Rewards
//
//  Created by Ranjith Gampa on 11/17/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var networking = RewardsNetworking()
    var dataSource = RewardsDataSource(networking: .init())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        triggerMockState()

        return true
    }
    
    private func setupWindow() {
        window = UIWindow()
        dataSource = RewardsDataSource(networking: networking)

        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = RewardsViewController(dataSource: dataSource)
        window?.makeKeyAndVisible()
    }
    
    private func triggerMockState() {
        let rewards = FetchRewards(
            rewards: [
                .init(itemId: 1, groupId: 1, name: "P1"),
                .init(itemId: 2, groupId: 1, name: "P2"),
                .init(itemId: 3, groupId: 1, name: "P3"),
                .init(itemId: 4, groupId: 2, name: "P1"),
                .init(itemId: 6, groupId: 2, name: "P3"),
                .init(itemId: 5, groupId: 2, name: "P2")
            ]
        )
        
        dataSource.state = .loading
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + 1.5,
            execute: { self.dataSource.state = .loaded(rewards) }
        )
    }

}


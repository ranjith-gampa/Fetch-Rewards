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

        return true
    }
    
    private func setupWindow() {
        window = UIWindow()
        dataSource = RewardsDataSource(networking: networking)

        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = RewardsViewController(dataSource: dataSource)
        window?.makeKeyAndVisible()
    }
}


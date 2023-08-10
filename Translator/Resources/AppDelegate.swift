//
//  AppDelegate.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit
import SwiftyStoreKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?
    var deviceOrientation = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return deviceOrientation
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                    for purchase in purchases {
                        switch purchase.transaction.transactionState {
                        case .purchased, .restored:
                            if purchase.needsFinishTransaction {
                                // Deliver content from server, then:
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }
                            // Unlock content
                        case .failed, .purchasing, .deferred:
                            break // do nothing
                        }
                    }
                }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


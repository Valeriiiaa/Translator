//
//  IAPManager.swift
//  Translator
//
//  Created by Valeriya Chernyak on 10.08.2023.
//

import Foundation
import SwiftyStoreKit

enum Products: String {
    case support = "translatorSub_1"
}

enum IAPStatus {
    case success(Products)
    case error(Error)
    case deffered
}

final class IAPManager {
    static let shared = IAPManager()
    
    func buyStandartPack() async -> IAPStatus {
        
        return await withCheckedContinuation({ continuation in
            SwiftyStoreKit.purchaseProduct(Products.support.rawValue, quantity: 1, atomically: true) { result in
                switch result {
                case .success(let purchase):
                    continuation.resume(returning: .success(.support))
                    //                    LocalStorageManager.shared.set(key: .isVIP, value: true)
//                    NotificationCenter.default.post(name: .isVIPChanged, object: nil)
                    print("Purchase Success: \(purchase.productId)")
                case .error(let error):
                    continuation.resume(returning: .error(error))
                case .deferred(purchase: let purchase):
                    continuation.resume(returning: .deffered)
                    print("[test] deffered")
                }
            }
        })
    }
    
    func restorePurchases() async -> Bool {
        return await withCheckedContinuation({ continuation in
            SwiftyStoreKit.restorePurchases(completion: { result in
                guard result.restoreFailedPurchases.isEmpty && !result.restoredPurchases.isEmpty else {
                    continuation.resume(returning: false)
                    return
                }
                //                LocalStorageManager.shared.set(key: .isVIP, value: true)
//                NotificationCenter.default.post(name: .isVIPChanged, object: nil)
                continuation.resume(returning: true)
            })
        })
    }
}

//
//  AppTrackingTransparencyManager.swift
//  Translator
//
//  Created by Kyrylo Chernov on 10.08.2023.
//

import Foundation
import AppTrackingTransparency

class AppTrackingTransparencyManager {
    enum Status {
        case success
        case restricted
    }
    
    func requestPermission() async -> AppTrackingTransparencyManager.Status {
        let resutl = await ATTrackingManager.requestTrackingAuthorization()
        switch resutl {
        case .authorized: return .success
        default: return .restricted
        }
    }
}

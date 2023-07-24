//
//  File.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//


import UIKit

extension UIView {
    
    func startRotation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = NSNumber(value: Double.pi * -2)
        rotation.duration = 1.0
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    
    func stopRotation() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
}


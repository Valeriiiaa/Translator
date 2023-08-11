//
//  PulseLayer.swift
//  Translator
//
//  Created by Kyrylo Chernov on 11.08.2023.
//

import UIKit

class PulseLayer: CALayer {
    
    private var animationGroup = CAAnimationGroup()
    
    private var initialPpulseScale: Float = 0
    private var nextPulseAfter: TimeInterval = 0
    private var animationDuration: TimeInterval = 1.5
    private var radius: CGFloat = 200
    private var numberOfPulses: Float = .infinity
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(numberOfPulses: Float = .infinity, radius: CGFloat, position: CGPoint) {
        super.init()
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.backgroundColor = UIColor.red.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.position = position
        self.bounds = .init(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        setupAnimationGroup()
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPpulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 1]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: .default)
        animationGroup.timingFunction = defaultCurve
        
        animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
}

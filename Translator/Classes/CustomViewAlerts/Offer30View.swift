//
//  Offer30%off.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class Offer30View: UIView {
    
    @IBOutlet weak var buyNowButton: UIButton!
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 89/255, green: 170/255, blue: 246/255, alpha: 1).cgColor,
            UIColor(red: 94/255, green: 82/255, blue: 240/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.2)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
       
        return gradient
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 22
        layer.masksToBounds = true
        buyNowButton.layer.cornerRadius = 15
        buyNowButton.layer.masksToBounds = true
        
        gradient.frame = buyNowButton.bounds
        buyNowButton.layer.insertSublayer(gradient, at: 0)
    }
    @IBAction func buyNowButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
     
    }
}

extension Offer30View {
    class func fromNib() -> Offer30View {
        return Bundle(for: Offer30View.self).loadNibNamed("Offer30View", owner: nil, options: nil)![0] as! Offer30View
    }
}

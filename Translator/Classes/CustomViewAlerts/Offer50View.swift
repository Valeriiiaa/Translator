//
//  Offer50%off.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class Offer50View: UIView {

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

extension Offer50View {
    class func fromNib() -> Offer50View {
        return Bundle(for: Offer50View.self).loadNibNamed("Offer50View", owner: nil, options: nil)![0] as! Offer50View
    }
}

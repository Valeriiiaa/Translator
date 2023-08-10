//
//  Offer30%off.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class Offer30View: UIView {
    
    @IBOutlet weak var buyNowButton: UIButton!
    
    var closeDidTap: (() -> Void)?
    var buySubscriptionDidTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 25
        layer.masksToBounds = true
        buyNowButton.layer.cornerRadius = 15
        buyNowButton.layer.masksToBounds = true
    }
    
    @IBAction func buyNowButtonDidTap(_ sender: Any) {
        closeDidTap?()
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        buySubscriptionDidTap?()
    }
}

extension Offer30View {
    class func fromNib() -> Offer30View {
        return Bundle(for: Offer30View.self).loadNibNamed("Offer30View", owner: nil, options: nil)![0] as! Offer30View
    }
}

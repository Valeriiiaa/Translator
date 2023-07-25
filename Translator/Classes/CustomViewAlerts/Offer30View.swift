//
//  Offer30%off.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class Offer30View: UIView {
    
    @IBOutlet weak var buyNowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 22
        layer.masksToBounds = true
        buyNowButton.layer.cornerRadius = 15
        buyNowButton.layer.masksToBounds = true
        
    }
    @IBAction func buyNowButtonDidTap(_ sender: Any) {
    }
    @IBAction func closeButtonDidTap(_ sender: Any) {
    }
    @IBAction func closeButtondidTap(_ sender: Any) {
    }
}

extension Offer30View {
    class func fromNib() -> Offer30View {
        return Bundle(for: Offer30View.self).loadNibNamed("Offer30View", owner: nil, options: nil)![0] as! Offer30View
    }
}

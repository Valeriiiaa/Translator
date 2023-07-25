//
//  Offer50%off.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class Offer50View: UIView {

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
}

extension Offer50View {
    class func fromNib() -> Offer50View {
        return Bundle(for: Offer50View.self).loadNibNamed("Offer50View", owner: nil, options: nil)![0] as! Offer50View
    }
}

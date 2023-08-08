//
//  ClearChatView.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit
import SwiftEntryKit

class ClearChatView: UIView {
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var deletedAllCellsTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.masksToBounds = true
        noButton.layer.cornerRadius = 10
        noButton.layer.masksToBounds = true
        noButton.layer.borderWidth = 2
        noButton.layer.borderColor = UIColor(red: 80/255, green: 142/255, blue: 245/255, alpha: 1).cgColor
        yesButton.layer.cornerRadius = 10
        yesButton.layer.masksToBounds = true
        
    }
    @IBAction func yesButtonDidTap(_ sender: Any) {
        deletedAllCellsTapped?()
    }
    @IBAction func noButtonDidTap(_ sender: Any) {
        SwiftEntryKit.dismiss()
    }
}

extension ClearChatView {
    class func fromNib() -> ClearChatView {
        return Bundle(for: ClearChatView.self).loadNibNamed("ClearChatView", owner: nil, options: nil)![0] as! ClearChatView
    }
}

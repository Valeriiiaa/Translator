//
//  PremiumImageCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class PremiumImageCell: UITableViewCell {

    @IBOutlet weak var buyNowButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        buyNowButton.layer.cornerRadius = 15
        buyNowButton.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

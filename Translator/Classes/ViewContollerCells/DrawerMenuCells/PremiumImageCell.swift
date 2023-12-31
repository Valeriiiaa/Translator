//
//  PremiumImageCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class PremiumImageCell: UITableViewCell {

    @IBOutlet weak var premiumImage: UIImageView!
    @IBOutlet weak var buyNowButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
//        premiumImage.image = premiumImage.image?.imageByMakingWhiteBackgroundTransparent()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
                 buyNowButton.layer.cornerRadius = 15
          
            
        default: buyNowButton.layer.cornerRadius = 25
        }
      
        
        buyNowButton.layer.masksToBounds = true
        buyNowButton.clipsToBounds = false
        buyNowButton.layer.shadowRadius = 4
        buyNowButton.layer.shadowOpacity = 0.3
        buyNowButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        buyNowButton.layer.shadowOffset = CGSize(width: 0, height: 4)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

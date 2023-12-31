//
//  SectionMenuCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 29.07.2023.
//

import UIKit

class SectionMenuCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var backgroundCellView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundCellView.layer.cornerRadius = 15
            flagImage.layer.cornerRadius = 3

        default: backgroundCellView.layer.cornerRadius = 25
                 flagImage.layer.cornerRadius = 6
        }
       
        flagImage.layer.masksToBounds = true
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.borderWidth = 2
        backgroundCellView.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configure(flagPicture: String, labelCountry: String) {
        countryLabel.text = labelCountry
        flagImage.image = UIImage(named: flagPicture)
        
    }

}

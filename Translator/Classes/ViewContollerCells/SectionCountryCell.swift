//
//  SectionCountryCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class SectionCountryCell: UITableViewCell {

    @IBOutlet weak var backgroundSelectionView: UIView!
    @IBOutlet weak var nameCountry: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundSelectionView.layer.cornerRadius = 15
            
            
        default:  backgroundSelectionView.layer.cornerRadius = 25
        }
        backgroundSelectionView.layer.masksToBounds = true
        backgroundSelectionView.layer.borderWidth = 2
        backgroundSelectionView.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(flagPicture: String, labelCountry: String) {
        nameCountry.text = labelCountry
        flagImage.image = UIImage(named: flagPicture)
        
    }

}

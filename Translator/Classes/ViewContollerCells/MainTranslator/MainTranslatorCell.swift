//
//  MainTranslatorCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class MainTranslatorCell: UICollectionViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageTranslatorView: UIImageView!
    @IBOutlet weak var backgroundMainTranslatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMainTranslatorView.layer.cornerRadius = 40
        backgroundMainTranslatorView.layer.masksToBounds = true
        backgroundMainTranslatorView.layer.borderWidth = 2
        backgroundMainTranslatorView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
    }
    
    func configure(label: String, image: String) {
        labelText.text = label
        imageTranslatorView.image = UIImage(named: image)
    }
}

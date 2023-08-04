//
//  SectionCountryCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit
import Combine

class SectionCountryCell: UITableViewCell {
    @IBOutlet weak var backgroundSelectionView: UIView!
    @IBOutlet weak var nameCountry: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    private var model: SelectionCountryModel?
    private var listeners = Set<AnyCancellable>()
   
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
    
    func configure(flagPicture: String, labelCountry: String) {
        nameCountry.text = labelCountry
        flagImage.image = UIImage(named: flagPicture)
    }
    
    func configure(model: SelectionCountryModel) {
        self.model = model
        nameCountry.text = model.key.name
        flagImage.image = UIImage(named: model.flagPicture)
        bind()
    }
    
    private func bind() {
        guard let model else { return }
        model.$isSelected.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            let backgroundColor = value ? UIColor(named: "LanguageSelectionColor") : .white
            self.backgroundSelectionView.backgroundColor = backgroundColor
            self.nameCountry.textColor = value ? .white : .black
        }).store(in: &listeners)
    }
}

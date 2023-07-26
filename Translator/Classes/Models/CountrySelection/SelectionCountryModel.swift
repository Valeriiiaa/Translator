//
//  SelectionCountryModels.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import Foundation

class SelectionCountryModel {
   
    let nameCountry: String
    let flagPicture: String
    let isSelected: Bool
    
    init(nameCountry: String, flagPicture: String, isSelected: Bool) {
        self.nameCountry = nameCountry
        self.flagPicture = flagPicture
        self.isSelected = isSelected
    }
}

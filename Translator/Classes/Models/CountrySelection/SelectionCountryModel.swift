//
//  SelectionCountryModels.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import Foundation
import Combine
import MLKitTranslate

extension TranslateLanguage: Codable {}

class SelectionCountryModel: Codable {
    let nameCountry: String
    let flagPicture: String
    let key: TranslateLanguage
    @Published var isSelected: Bool
    
    init(nameCountry: String, flagPicture: String, isSelected: Bool, key: TranslateLanguage) {
        self.nameCountry = nameCountry
        self.flagPicture = flagPicture
        self.isSelected = isSelected
        self.key = key
    }
    
    enum CodingKeys: CodingKey {
        case nameCountry
        case flagPicture
        case key
        case isSelected
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nameCountry, forKey: .nameCountry)
        try container.encode(flagPicture, forKey: .flagPicture)
        try container.encode(key, forKey: .key)
        try container.encode(isSelected, forKey: .isSelected)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nameCountry = try container.decode(String.self, forKey: .nameCountry)
        flagPicture = try container.decode(String.self, forKey: .flagPicture)
        key = try container.decode(TranslateLanguage.self, forKey: .key)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
}

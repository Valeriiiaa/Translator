//
//  SelectionCountryModels.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import Foundation
import Combine
import MLKitTranslate

extension TranslateLanguage: Decodable {}

class SelectionCountryModel: Decodable {
    let nameCountry: String
    let flagPicture: String
    let key: TranslateLanguage
    @Published var isSelected: Bool
    
    init(nameCountry: String, flagPicture: String, isSelected: Bool, key: TranslateLanguage) {
        self.nameCountry = nameCountry
        self.flagPicture = flagPicture
        self.isSelected = isSelected
        self.key = key
        key.name
    }
    
    enum CodingKeys: CodingKey {
        case nameCountry
        case flagPicture
        case key
        case isSelected
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nameCountry = try container.decode(String.self, forKey: .nameCountry)
        flagPicture = try container.decode(String.self, forKey: .flagPicture)
        key = try container.decode(TranslateLanguage.self, forKey: .key)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
}

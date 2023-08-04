//
//  LanguageManager.swift
//  Translator
//
//  Created by Kyrylo Chernov on 04.08.2023.
//

import Foundation

class LanguageManager {
    private let storage: UserDefaultsStorage
    @Published public var originalLanguage: SelectionCountryModel
    @Published public var translatedLanguage: SelectionCountryModel
    
    init(storage: UserDefaultsStorage) {
        self.storage = storage
        let originalLanguageStored: SelectionCountryModel = storage.get(key: .originalLanguage, defaultValue: SelectionCountryModel(nameCountry: "English", flagPicture: "en", isSelected: true, key: .english))
        let locale = Locale.current.language.minimalIdentifier
        let translatedLanguageStored: SelectionCountryModel = storage.get(key: .translatedLanguage, defaultValue: SelectionCountryModel(nameCountry: Locale.current.language.minimalIdentifier, flagPicture: Locale.current.language.minimalIdentifier, isSelected: true, key: .init(rawValue: Locale.current.language.minimalIdentifier)))
        self.originalLanguage = originalLanguageStored
        self.translatedLanguage = translatedLanguageStored
    }
}

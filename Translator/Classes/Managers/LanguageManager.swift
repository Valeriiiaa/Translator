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
        let translatedLanguageStored: SelectionCountryModel = storage.get(key: .originalLanguage, defaultValue: SelectionCountryModel(nameCountry: "English", flagPicture: "en", isSelected: true, key: .english))
        let locale = Locale.preferredLanguages.first?.components(separatedBy: "-")[0] ?? "uk"
        let languangeName = Locale.current.localizedString(forLanguageCode: locale) ?? ""
        let originalLanguageStored: SelectionCountryModel = storage.get(key: .translatedLanguage, defaultValue: SelectionCountryModel(nameCountry: languangeName, flagPicture: locale, isSelected: true, key: .init(rawValue: locale)))
        self.originalLanguage = originalLanguageStored
        self.translatedLanguage = translatedLanguageStored
    }
}

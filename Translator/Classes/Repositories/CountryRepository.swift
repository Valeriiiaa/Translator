//
//  CountryRepository.swift
//  Translator
//
//  Created by Kyrylo Chernov on 02.08.2023.
//

import Foundation
import MLKitTranslate

struct LanguageModel {
    public let key: String
    public let name: String
}

class CountryRepository {
    public var languages = [LanguageModel]()
    
    init() {
        languages = TranslateLanguage.allLanguages().map({ language in
                .init(key: language.rawValue, name: language.name)
        })
    }
}

extension TranslateLanguage {
    var name: String {
        switch self {
        case .afrikaans: return "Afrikaans"
        default: return String(describing: self)
        }
    }
}

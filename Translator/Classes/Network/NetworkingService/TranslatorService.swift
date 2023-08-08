//
//  TranslatorService.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

struct TranslatorService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func translate(from: String, to: String, text: String) async throws -> String {
        let descriptor = GoogleTranslatePrivateAPIDescriptor(text: text, from: from, to: to)
        let responseModel: TranslationContainerModel = try await networkManager.request(with: descriptor, jwtToken: nil)
        let translations = responseModel.alternativeTranslations
        let text = translations.enumerated().map({ translation in
            guard let alternative = translation.element.alternative?.first else {
                return translation.element.srcPhrase
            }
            let newIndex = translation.offset + 1
            let shouldCheck = translations.endIndex >= newIndex
            var space = ""
            if shouldCheck {
                let nextTranslation = translations[translation.offset]
                space = nextTranslation.srcPhrase == "\n" ? "" : " "
            }
            return alternative.wordPostproc + space
        })
        return text.joined()
    }
}

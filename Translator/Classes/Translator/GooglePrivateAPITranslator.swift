//
//  GooglePrivateAPITranslator.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

class GooglePrivateAPITranslator: TextTranslator {
    private let translatorService: TranslatorService
    
    init(translatorService: TranslatorService) {
        self.translatorService = translatorService
    }
    
    func translate(text: String, from: String, to: String) async throws -> String {
        try await translatorService.translate(from: from, to: to, text: text)
    }
}

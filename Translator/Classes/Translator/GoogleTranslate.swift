//
//  GoogleTranslate.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation
import MLKitTranslate

class GoogleTranslate {
    private(set) var option: TranslatorOptions?
    private(set) var translator: Translator?
    
    private func loadTranslateModel() async throws {
        guard let translator else {
            print("[log] translator is nil")
            return
        }
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        try await translator.downloadModelIfNeeded(with: conditions)
    }
    
    public func translate(text: String, from: TranslateLanguage, to: TranslateLanguage) async throws -> String {
        var tmpText = text
        var tmpFrom = from
        if from != .english && to != .english {
            tmpText = try await translateToEnglish(text: tmpText, from: from)
            tmpFrom = .english
        }
        let option = TranslatorOptions(sourceLanguage: tmpFrom, targetLanguage: to)
        let translator = Translator.translator(options: option)
        self.translator = translator
        try await loadTranslateModel()
        return try await translator.translate(tmpText)
    }
    
    private func translateToEnglish(text: String, from: TranslateLanguage) async throws -> String {
        let option = TranslatorOptions(sourceLanguage: from, targetLanguage: .english)
        let translator = Translator.translator(options: option)
        try await loadTranslateModel()
        return try await translator.translate(text)
    }
}

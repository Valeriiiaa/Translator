//
//  HistoryFullModel.swift
//  Translator
//
//  Created by Valeriya Chernyak on 03.08.2023.
//

import Foundation

class HistoryFullModel: BaseHistoryModel {
    
    let id: String
    let originalText: String
    let translatedText: String
    let firstFlag: String
    let secondFlag: String
    let firstLanguageLabel: String
    let secondLanguageLabel: String
    
    init(id: String, originalText: String, translatedText: String, firstFlag: String, secondFlag: String, firstLanguageLabel: String, secondLanguageLabel: String) {
        self.id = id
        self.originalText = originalText
        self.translatedText = translatedText
        self.firstFlag = firstFlag
        self.secondFlag = secondFlag
        self.firstLanguageLabel = firstLanguageLabel
        self.secondLanguageLabel = secondLanguageLabel
    }
}

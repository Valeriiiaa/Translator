//
//  TextTranslator.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

protocol TextTranslator {
    func translate(text: String, from: String, to: String) async throws -> String
}

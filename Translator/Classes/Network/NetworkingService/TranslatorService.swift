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
        let reponseModel: TranslationContainerModel = try await networkManager.request(with: descriptor, jwtToken: nil)
        let resutl = reponseModel.alternativeTranslations.first?.alternative.first?.wordPostproc ?? ""
        return resutl
    }
}

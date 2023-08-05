//
//  GoogleTranslatePrivateAPIDescriptor.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

struct GoogleTranslatePrivateAPIDescriptor: Descriptor {
    var url: String
    var httpMethod: HttpMethod
    var contentType: ContentType
    var parameters: [URLQueryItem] = []
    var body: Codable?
    
    init(text: String, from: String, to: String) {
        url = "https://translate.google.com/translate_a/single"
        httpMethod = .get
        contentType = .json
        body = nil
        configureParameters(text: text, from: from, to: to)
    }
    
//https://translate.google.com/translate_a/single?client=gtx&sl=en&tl=ru&hl=en&ie=UTF-8&oe=UTF-8&otf=1&ssel=0&tsel=0&kc=7&q=Hello&dt=at&dj=1
    
    mutating private func configureParameters(text: String, from: String, to: String) {
        parameters.append(.init(name: "client", value: "gtx"))
        parameters.append(.init(name: "sl", value: from))
        parameters.append(.init(name: "tl", value: to))
        parameters.append(.init(name: "hl", value: "en"))
        parameters.append(.init(name: "ie", value: "UTF-8"))
        parameters.append(.init(name: "oe", value: "UTF-8"))
        parameters.append(.init(name: "otf", value: "1"))
        parameters.append(.init(name: "ssel", value: "0"))
        parameters.append(.init(name: "tsel", value: "0"))
        parameters.append(.init(name: "kc", value: "7"))
        parameters.append(.init(name: "q", value: text))
        parameters.append(.init(name: "dt", value: "at"))
//        parameters.append(.init(name: "dt", value: "bd"))
//        parameters.append(.init(name: "dt", value: "ex"))
//        parameters.append(.init(name: "dt", value: "ld"))
//        parameters.append(.init(name: "dt", value: "md"))
//        parameters.append(.init(name: "dt", value: "qca"))
//        parameters.append(.init(name: "dt", value: "rw"))
//        parameters.append(.init(name: "dt", value: "rm"))
//        parameters.append(.init(name: "dt", value: "ss"))
//        parameters.append(.init(name: "dt", value: "t"))
        parameters.append(.init(name: "dj", value: "1"))
    }
}

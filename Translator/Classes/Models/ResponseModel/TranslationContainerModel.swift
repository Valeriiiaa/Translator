//
//  TranslationContainerModel.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

struct TranslationContainerModel: Codable {
    let src: String
    let alternativeTranslations: [AlternativeTranslation]
    let spell: Spell

    enum CodingKeys: String, CodingKey {
        case src
        case alternativeTranslations = "alternative_translations"
        case spell
    }
}

// MARK: - AlternativeTranslation
struct AlternativeTranslation: Codable {
    let srcPhrase: String
    let alternative: [Alternative]
    let srcunicodeoffsets: [Srcunicodeoffset]
    let rawSrcSegment: String
    let startPos, endPos: Int

    enum CodingKeys: String, CodingKey {
        case srcPhrase = "src_phrase"
        case alternative, srcunicodeoffsets
        case rawSrcSegment = "raw_src_segment"
        case startPos = "start_pos"
        case endPos = "end_pos"
    }
}

// MARK: - Alternative
struct Alternative: Codable {
    let wordPostproc: String
    let score: Int
    let hasPrecedingSpace, attachToNextToken: Bool
    let backends: [Int]
    let backendInfos: [BackendInfo]?

    enum CodingKeys: String, CodingKey {
        case wordPostproc = "word_postproc"
        case score
        case hasPrecedingSpace = "has_preceding_space"
        case attachToNextToken = "attach_to_next_token"
        case backends
        case backendInfos = "backend_infos"
    }
}

// MARK: - BackendInfo
struct BackendInfo: Codable {
    let backend: Int
}

// MARK: - Srcunicodeoffset
struct Srcunicodeoffset: Codable {
    let begin, end: Int
}

// MARK: - Spell
struct Spell: Codable {
}

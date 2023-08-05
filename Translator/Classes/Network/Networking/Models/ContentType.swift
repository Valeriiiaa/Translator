//
//  ContentType.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

enum ContentType: CustomStringConvertible {
    case json
    case multipartFormData
    
    var description: String {
        switch self {
        case .json:
            return "application/json"
        case .multipartFormData:
            return "multipart/form-data"
        }
    }
}

//
//  HttpMethod.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

enum HttpMethod: CustomStringConvertible {
    case post
    case get
    
    var description: String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        }
    }
}

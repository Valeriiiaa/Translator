//
//  NetworkError.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case unknownError
}

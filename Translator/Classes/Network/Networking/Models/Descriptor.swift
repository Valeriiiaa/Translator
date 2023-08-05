//
//  Descriptor.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

protocol Descriptor {
    var httpMethod: HttpMethod { get }
    var contentType: ContentType { get set }
    var url: String { get set }
    var parameters: [URLQueryItem] { get set }
    var body: Codable? { get set }
}

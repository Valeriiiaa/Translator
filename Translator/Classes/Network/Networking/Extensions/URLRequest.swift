//
//  URLRequest.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

extension URLRequest {
    mutating func setupHeaders(params: [URLQueryItem]) -> Self {
        params.forEach({ param in
            self.addValue(param.value ?? "", forHTTPHeaderField: param.name)
        })
        return self
    }
    
    mutating func setupContentType(_ contentType: ContentType) -> Self {
        self.addValue(contentType.description, forHTTPHeaderField: "Content-Type")
        return self
    }
    
    mutating func setupHttpMethod(_ httpMethod: HttpMethod) -> Self {
        self.httpMethod = httpMethod.description
        return self
    }
    
    mutating func setupBody(_ body: Codable?) throws -> Self {
        guard let body else { return self }
        self.httpBody = try JSONEncoder().encode(body)
        return self
    }
    
    mutating func setupAuthorization(token: String?) -> Self {
        guard let token else { return self }
        self.addValue(token, forHTTPHeaderField: "Authorization")
        return self
    }
}

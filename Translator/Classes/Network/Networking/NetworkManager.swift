//
//  NetworkManager.swift
//  Translator
//
//  Created by Kyrylo Chernov on 05.08.2023.
//

import Foundation

class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(with descriptor: Descriptor, jwtToken: String?) async throws -> T {
        let request = try makeRequest(for: descriptor, jwtToken: jwtToken)
        let response = try await session.data(for: request)
        let data = response.0
        return try decode(data: data)
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
    
    private func makeRequest(for descriptor: Descriptor, jwtToken: String?) throws -> URLRequest {
        guard let url = URL(string: descriptor.url) else {
            throw NetworkError.invalidURL
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        urlComponents.queryItems = descriptor.parameters
        guard let composedURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: composedURL)
        urlRequest = urlRequest.setupHttpMethod(descriptor.httpMethod)
        urlRequest = urlRequest.setupContentType(descriptor.contentType)
        urlRequest = try urlRequest.setupBody(descriptor.body)
        urlRequest = urlRequest.setupAuthorization(token: jwtToken)
        return urlRequest
    }
}

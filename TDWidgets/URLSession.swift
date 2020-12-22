//
//  URLSession.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/15/20.
//

import Combine
import Foundation

protocol NetworkSession: AnyObject {
    func publisher(for urlRequest: URLRequest, token: Token?) -> AnyPublisher<Data, Error>
}

extension URLSession: NetworkSession {
    func publisher(for urlRequest: URLRequest, token: Token?) -> AnyPublisher<Data, Error> {
        var request = urlRequest
        if let token = token {
            request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authentication")
        }
        return dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
    }
}

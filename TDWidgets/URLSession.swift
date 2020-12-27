//
//  URLSession.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/15/20.
//

import Combine
import Foundation
import os

protocol NetworkSession: AnyObject {
    func publisher(for urlRequest: URLRequest, token: Token?) -> AnyPublisher<Data, Error>
}

extension URLSession: NetworkSession {
    func publisher(for urlRequest: URLRequest, token: Token?) -> AnyPublisher<Data, Error> {
        var request = urlRequest
        let logger = Logger(subsystem: self.description, category: "NetworkSessionPublisher")
        if let token = token {
            request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        logger.debug("Verb: \(request.httpMethod ?? "", privacy: .public) URL: \(request.url?.absoluteString ?? "", privacy: .public) Headers: \(String(describing: request.allHTTPHeaderFields), privacy: .public)")

        return dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                logger.debug("StatusCode: \(httpResponse.statusCode, privacy: .public)")
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
                }

                return element.data
            }
            .eraseToAnyPublisher()
    }
}

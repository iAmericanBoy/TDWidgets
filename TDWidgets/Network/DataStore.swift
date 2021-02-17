//
//  DataStore.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/30/20.
//

import Combine
import Foundation

protocol DataStore {
    func getAccouts() -> AnyPublisher<AccountDataModel, Error>
    func getMarketHours(for date: String) -> AnyPublisher<MarketDataModel, Error>
}

class DataStoreImpl: DataStore {
    private let session: NetworkSession
    private let authenticator: Authenticator

    init(session: NetworkSession = URLSession.shared) {
        // Add singleton pattern
        self.session = session
        self.authenticator = Authenticator(session: session)
    }

    func getAccouts() -> AnyPublisher<AccountDataModel, Error> {
        var components = URLComponents(string: "https://api.tdameritrade.com/v1/accounts")
        components?.queryItems = [URLQueryItem(name: "fields", value: "positions")]
        guard let url = components?.url else {
            return Fail(error: RepositoryError.urlComponents)
                .eraseToAnyPublisher()
        }

        return performAuthenticatedRequest(URLRequest(url: url))
    }

    func getMarketHours(for date: String) -> AnyPublisher<MarketDataModel, Error> {
        var components = URLComponents(string: "https://api.tdameritrade.com/v1/marketdata/hours")
        components?.queryItems = [URLQueryItem(name: "markets", value: "EQUITY"),
                                  URLQueryItem(name: "date", value: date)]
        guard let url = components?.url else {
            return Fail(error: RepositoryError.urlComponents)
                .eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return performAuthenticatedRequest(URLRequest(url: url),decoder: decoder)
    }

    private func performAuthenticatedRequest<T: Decodable>(_ request: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return authenticator.validAccessToken()
            .flatMap { accessToken in
                // we can now use this token to authenticate the request
                self.session.publisher(for: request, accessToken: accessToken)
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                guard let serviceError = error as? URLError, serviceError.code.rawValue == 401 else {
                    throw error
                }

                return self.authenticator.validAccessToken(forceRefresh: true)
                    .flatMap { accessToken in
                        // we can now use this new token to authenticate the second attempt at making this request
                        self.session.publisher(for: request, accessToken: accessToken)
                    }
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

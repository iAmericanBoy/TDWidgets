//
//  Repository.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Combine
import Foundation

enum RepositoryError: Error {
    case urlComponents
}

protocol Repository {
    func getAccouts() -> AnyPublisher<AccountDataModel, Error>
}

class RepositoryImpl: Repository {
    private let session: NetworkSession
    private let authenticator: Authenticator

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
        self.authenticator = Authenticator(session: session)
    }

    func getAccouts() -> AnyPublisher<AccountDataModel, Error> {
        var components = URLComponents(string: "https://api.tdameritrade.com/v1/accounts")
        components?.queryItems = [URLQueryItem(name: "fields", value: "positions,orders")]
        guard let url = components?.url else {
            return Fail(error: RepositoryError.urlComponents)
                .eraseToAnyPublisher()
        }

        return performAuthenticatedRequest(URLRequest(url: url))
    }

    private func performAuthenticatedRequest<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        let request = URLRequest(url: URL(string: "https://donnys-app.com/authenticated/resource")!)

        return authenticator.validAccessToken()
            .flatMap { token in
                // we can now use this token to authenticate the request
                self.session.publisher(for: request, token: token)
            }
            .tryCatch { error -> AnyPublisher<Data, Error> in
                guard let serviceError = error as? URLError, serviceError.code.rawValue == 401 else {
                    throw error
                }

                return self.authenticator.validAccessToken(forceRefresh: true)
                    .flatMap { token in
                        // we can now use this new token to authenticate the second attempt at making this request
                        self.session.publisher(for: request, token: token)
                    }
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

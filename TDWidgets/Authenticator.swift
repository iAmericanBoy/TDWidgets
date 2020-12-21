//
//  Authenticator.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/15/20.
//  Based on https://www.donnywals.com/building-a-concurrency-proof-token-refresh-flow-in-combine/
//

import Combine
import Foundation

// TODO: this only works to refresh the access token. figure out a way of how you can get the refresh token after a login flow
class Authenticator {
    private let session: NetworkSession

    private var currentToken: Token? {
        get {
            if let savedToken = UserDefaults.standard.object(forKey: "Authenticator.refreshToken") as? Data {
                let decoder = JSONDecoder()
                if let token = try? decoder.decode(Token.self, from: savedToken) {
                    return token
                }
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "Authenticator.refreshToken")
            }
        }
    }

    private var code: String? {
        UserDefaults.standard.string(forKey: "OAuthManager.code")
    }

    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")

    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<Token, Error>?

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func validAccessToken(forceRefresh: Bool = false) -> AnyPublisher<Token, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }

            // scenario 2: we don't have a token at all, the user should probably log in
            guard let token = self?.currentToken else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }

            // scenario 3: we already have a valid token and don't want to force a refresh
            if token.isValidAccessToken(), !forceRefresh {
                return Just(token)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            // scenario 4: we need a new token
            let publisher = session.publisher(for: request(), token: nil)
                .share()
                .decode(type: Token.self, decoder: JSONDecoder())
                .handleEvents(receiveOutput: { token in
                    self?.currentToken = token
                }, receiveCompletion: { _ in
                    self?.queue.sync {
                        self?.refreshPublisher = nil
                    }
                })
                .eraseToAnyPublisher()

            self?.refreshPublisher = publisher
            return publisher
        }
    }

    enum AuthenticationError: Error {
        case loginRequired
    }

    private func request() -> URLRequest {
        let endpoint = URL(string: "https://api.tdameritrade.com/v1/oauth2/token")!
        var request = URLRequest(url: endpoint)
        request.addValue("", forHTTPHeaderField: "client_id")

        guard let token = currentToken else {
            request.addValue("authorization_code", forHTTPHeaderField: "grant_type")
            request.addValue("offline", forHTTPHeaderField: "access_type")
            request.addValue(code ?? "", forHTTPHeaderField: "code")
            request.addValue("https://localhost", forHTTPHeaderField: "redirect_uri")

            return request
        }

        request.addValue("refresh_token", forHTTPHeaderField: "grant_type")
        request.addValue(token.refreshToken, forHTTPHeaderField: "refresh_token")

        if token.isTimeToRefreshToken() {
            request.addValue("offline", forHTTPHeaderField: "access_type")
        }

        return request
    }
}

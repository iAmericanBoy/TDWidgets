//
//  Authenticator.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/15/20.
//  Based on https://www.donnywals.com/building-a-concurrency-proof-token-refresh-flow-in-combine/
//

import Combine
import Foundation
import os

enum AuthenticationError: Error {
    case loginRequired
}

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
        get {
            UserDefaults.standard.string(forKey: "OAuthManager.code")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OAuthManager.code")
        }
    }

    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")

    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<AccessToken, Error>?

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func validAccessToken(forceRefresh: Bool = false) -> AnyPublisher<AccessToken, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }

            // scenario 2: we don't have a token at all, the user should probably log in
            guard let token = self?.currentToken else {
                // try to get a current token if code is set
                if code != nil {
                    let publisher = getToken()

                    self?.refreshPublisher = publisher
                    return publisher
                } else {
                    return Fail(error: AuthenticationError.loginRequired)
                        .eraseToAnyPublisher()
                }
            }

            // scenario 3: we already have a valid token and don't want to force a refresh
            if token.isValidAccessToken(), !forceRefresh {
                return Just(token.accessToken)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }

            // scenario 4: we need a new token
            let publisher = getToken()

            self?.refreshPublisher = publisher
            return publisher
        }
    }

    private func getToken() -> AnyPublisher<AccessToken, Error> {
        return session.publisher(for: request(), accessToken: nil)
            .share()
            .decode(type: TokenDataModel.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { token in
                self.update(token)
            }, receiveCompletion: { _ in
                self.queue.sync {
                    self.refreshPublisher = nil
                }
            })
            .map { $0.accessToken }
            .eraseToAnyPublisher()
    }

    private func update(_ token: TokenDataModel) {
        let logger = Logger(subsystem: "Authenticator", category: "getToken")
        var updateToken: Token
        if let currentToken = self.currentToken {
            logger.debug("Token loaded form Disk")
            updateToken = currentToken
            logger.debug("Updated AccessToken")
            updateToken.accessToken = token.accessToken
            updateToken.tokenType = token.tokenType
            updateToken.expiresIn = token.expiresIn
            updateToken.scope = token.scope
            updateToken.date = Date()
        } else {
            logger.error("Unable to load current Token from disk")
            guard let refreshToken = token.refreshToken, let refreshTokenExpiresIn = token.refreshTokenExpiresIn else {
                logger.error("Need to set a new token but there is no Refresh Token")
                return
            }
            updateToken = Token(accessToken: token.accessToken, refreshToken: refreshToken, tokenType: token.tokenType, expiresIn: token.expiresIn, scope: token.scope, refreshTokenExpiresIn: refreshTokenExpiresIn)
        }

        if let refreshToken = token.refreshToken, let refreshTokenExpiresIn = token.refreshTokenExpiresIn {
            logger.debug("Updated RefreshToken")
            updateToken.refreshToken = refreshToken
            updateToken.refreshTokenExpiresIn = refreshTokenExpiresIn
        }
        currentToken = updateToken
    }

    private func request() -> URLRequest {
        let endpoint = URL(string: "https://api.tdameritrade.com/v1/oauth2/token")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        guard let token = currentToken else {
            let codeString = "client_id=\(AppSecrets.clientID)&grant_type=authorization_code&access_type=offline&code=\(code?.stringByAddingPercentEncodingForRFC3986() ?? "")&redirect_uri=tdWidgets://auth"
            request.httpBody = Data(codeString.utf8)
            code = nil
            return request
        }

        var refreshString = "client_id=\(AppSecrets.clientID)&grant_type=refresh_token&refresh_token=\(token.refreshToken.stringByAddingPercentEncodingForRFC3986() ?? "")&redirect_uri=tdWidgets://auth"

        if token.isTimeToRefreshToken() {
            refreshString += "&access_type=offline"
        }

        request.httpBody = Data(refreshString.utf8)
        return request
    }
}

private extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?+"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.removeCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}

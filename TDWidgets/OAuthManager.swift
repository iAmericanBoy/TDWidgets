//
//  OAuthManager.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/5/20.
//

import AuthenticationServices
import SafariServices
import UIKit

enum OAuthError: Error {
    case noToken
    case sessionError(error: Error)
}

/**
 Manages / Abstracts out OAuth.
 */
public protocol OAuthManagerProtocol {
    // MARK: - Members

    /// In an authorized state. Valid token, can call services
    var isAuthorized: Bool { get }

    // MARK: - Methods

    /**
     Attempt to authenticate.
     - viewController: ViewController to host embedded Safari
     - completion: Called result of the authenticate call
     */
    func signIn(context: ASWebAuthenticationPresentationContextProviding,
                completion: @escaping (Result<Void, Error>) -> Void)
    /**
     Sign out. Require successful sign in before services can be
     called again.
     */
    func signOut(viewController: UIViewController,
                 completion: @escaping (Result<Void, Error>) -> Void)

    func fetchClientToken(completion: @escaping (Result<Void, Error>) -> Void)
}

public final class OAuthManager: NSObject, OAuthManagerProtocol {
    // MARK: - Members

    var webAuthSession: ASWebAuthenticationSession?

    // MARK: - Auth Token

    private let authTokenKey = ""
    private let clientID = ""
    private let callbackUrlScheme = "https://localhost"

    override public init() {}

    public var isAuthorized: Bool {
        return false
    }

    public func signIn(context: ASWebAuthenticationPresentationContextProviding, completion: @escaping (Result<Void, Error>) -> Void) {
        var urlComponents = URLComponents(url: URL(string: "https://auth.tdameritrade.com/auth")!, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "response_type", value: "code"),
                                     URLQueryItem(name: "redirect_uri", value: callbackUrlScheme),
                                     URLQueryItem(name: "client_id", value: authTokenKey + "@AMER.OAUTHAP")]
        guard let url = urlComponents?.url else {
            return
        }

        webAuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackUrlScheme, completionHandler: { [weak self] authSessionURL, error in
            guard error == nil, let successURL = authSessionURL else {
                completion(.failure(OAuthError.sessionError(error: error!)))
                return
            }
            let successURLComponents = URLComponents(url: successURL, resolvingAgainstBaseURL: true)
            let token = successURLComponents?.queryItems?.first(where: { $0.name == "code" })

            guard let refreshToken = token?.value else {
                completion(.failure(OAuthError.noToken))
                return
            }
            self?.storeToken(refreshToken)
        })

        webAuthSession?.presentationContextProvider = context
        webAuthSession?.prefersEphemeralWebBrowserSession = true
        webAuthSession?.start()
    }

    /*
     The client token to be able to access backend APIs: Needs to be tested and debuged with backend as
     we are getting an error.
     Implementation taken from OAUth2
     */
    public func fetchClientToken(completion _: @escaping (Result<Void, Error>) -> Void) {}

    public func signOut(viewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {}

    private func storeToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "refreshToken")
    }
}

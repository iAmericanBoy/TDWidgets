//
//  OAuthManager.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/5/20.
//

import AuthenticationServices
import SafariServices
import UIKit

/**
 Manages / Abstracts out SSO.
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

public final class SSOManager: NSObject, OAuthManagerProtocol {
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
                                     URLQueryItem(name: "client_id", value: authTokenKey + "%40AMER.OAUTHAP")]

        guard let url = urlComponents?.url else {
            return
        }

        webAuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackUrlScheme, completionHandler: { authSessionURL, error in
            guard error == nil, let successURL = authSessionURL else {
                completion(.failure(error!))
                return
            }

            print(successURL)
        })

        webAuthSession?.presentationContextProvider = context
        webAuthSession?.prefersEphemeralWebBrowserSession = true // Avoid using any existing browsing data, like cookies
        webAuthSession?.start()
    }

    /*
     The client token to be able to access backend APIs: Needs to be tested and debuged with backend as
     we are getting an error.
     Implementation taken from OAUth2
     */
    public func fetchClientToken(completion _: @escaping (Result<Void, Error>) -> Void) {}

    public func signOut(viewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {}
}

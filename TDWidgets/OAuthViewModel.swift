//
//  OAuthViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/5/20.
//

import AuthenticationServices
import Foundation

class OAuthViewModel {
    private let oAuthManager: OAuthManagerProtocol
    weak var context: ASWebAuthenticationPresentationContextProviding?
    
    init(oAuthManager: OAuthManagerProtocol = OAuthManager()) {
        self.oAuthManager = oAuthManager
    }
    
    func signIn() {
        if let context = context {
            oAuthManager.signIn(context: context) { [weak self] response in
                switch response {
                case .success():
                    print()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

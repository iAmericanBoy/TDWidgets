//
//  OAuthViewController.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/5/20.
//

import AuthenticationServices
import SwiftUI
import UIKit

class OAuthViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    private var viewModel: OAuthViewModel
    
    init(viewModel: OAuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.context = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.signIn()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}

final class OAuthView: NSObject, UIViewControllerRepresentable {
    private var viewModel: OAuthViewModel
    
    init(viewModel: OAuthViewModel = OAuthViewModel()) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> OAuthViewController {
        return OAuthViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: OAuthViewController, context: Context) {}
}

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
    // MARK: Member
    
    private var viewModel: OAuthViewModel
    
    // MARK: Lifecycle
    
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
    
    private var onDismiss: () -> Void
    
    init(viewModel: OAuthViewModel = OAuthViewModel(), onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
    }
    
    func makeUIViewController(context: Context) -> OAuthViewController {
        viewModel.delegate = context.coordinator
        return OAuthViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: OAuthViewController, context: Context) {}
    
    class Coordinator: OAuthViewModelDelegate {
        var parent: OAuthView
        
        internal init(_ parent: OAuthView) {
            self.parent = parent
        }
        
        func dismissView() {
            parent.onDismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

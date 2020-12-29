//
//  AccountWidgetViewModel.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import Foundation
import Combine


class AccountWidgetViewModel {
    
    // MARK: Members:

    private let repository: Repository

    // MARK: Subscribers:

    private var accountsSubscriber: AnyCancellable?
    
    init(repository: Repository = RepositoryImpl()) {
        self.repository = repository
        getAccounts()
    }
    
    private func getAccounts() {
        
    }
}

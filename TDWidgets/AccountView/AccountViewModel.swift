//
//  AccountViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Combine
import Foundation

class AccountViewModel: ObservableObject {
    // MARK: Members:

    private let repository: Repository

    // MARK: Subscribers:

    private var accountsSubscriber: AnyCancellable?

    // MARK: Model

    @Published private var account: Account?

    init(repository: Repository = RepositoryImpl()) {
        self.repository = repository
    }

    func getAccounts() {
        accountsSubscriber = repository.getAccouts()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { accountsDataModel in
                print(accountsDataModel)
                self.account = Account(accountsDataModel[0])
            })
    }
}

// MARK: AccountHeaderViewModel

extension AccountViewModel {
    var title: String {
        return "\(account?.type ?? "") account"
    }

    var balance: String {
        return "\(account?.longStockValue ?? 0)"
    }

    var arrowImageName: String {
        return account?.longStockDifference ?? 1 > 0 ? "arrow.up" : "arrow.down"
    }

    var balanceSubTitle: String {
        return "\(account?.longStockDifference ?? 0)"
    }
}

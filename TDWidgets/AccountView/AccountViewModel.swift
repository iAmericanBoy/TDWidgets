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
    private var simpleStockPositions: [SimpleStockRowViewModel] = []
    @Published var shouldShowSignIn: Bool = false

    init(repository: Repository = RepositoryImpl()) {
        self.repository = repository
        getAccounts()
    }

    func getAccounts() {
        accountsSubscriber = repository.getAccouts()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error as AuthenticationError) where error == .loginRequired:
                    self.shouldShowSignIn = true
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { accountsDataModel in
                self.account = Account(accountsDataModel[0])
                self.simpleStockPositions = accountsDataModel[0].securitiesAccount.positions?.compactMap { (position) -> SimpleStockRowViewModel in
                    SimpleStockRowViewModel(position)
                } ?? []
            })
    }
}

// MARK: - AccountHeaderView

extension AccountViewModel {
    var title: String {
        return "\(account?.type ?? "") account"
    }

    var balance: String {
        return "\(account?.longMarginValue ?? 0)"
    }

    var arrowImageName: String {
        return account?.longMarginDifferenceValue ?? 1 > 0 ? "arrow.up" : "arrow.down"
    }

    var balanceSubTitle: String {
        return "\(account?.longMarginDifferenceValue ?? 0)"
    }
}

// MARK: - SimpleStockView

extension AccountViewModel {
    var simpleStockRowViewModel: [SimpleStockRowViewModel] {
        simpleStockPositions
    }
}

//
//  AccountViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Combine
import SwiftUI

class AccountViewModel: ObservableObject {
    // MARK: Members:

    private let repository: Repository

    // MARK: Subscribers:

    private var accountsSubscriber: AnyCancellable?

    // MARK: Model

    @Published private var account: Account?
    private var simpleStockPositions: [SimpleStockRowViewModel] = []
    @Published var shouldShowSignIn: Bool = false
    @Published var shouldStreamData: Bool = true

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
                if self.shouldStreamData {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.getAccounts()
                    }
                }
            })
    }
}

// MARK: - AccountHeaderView

extension AccountViewModel {
    func streamData() {
        if shouldStreamData == false {
            getAccounts()
        }
        shouldStreamData.toggle()
    }

    private var dayProfitLossPercentage: Decimal {
        guard let initialEquity = account?.initialEquity, let currentLongMarginValue = account?.currentEquity else {
            return 0
        }
        let math = (currentLongMarginValue - initialEquity) / currentLongMarginValue * 100
        return math
    }

    var title: String {
        "\(account?.type ?? "") account"
    }

    var streamDataImageString: String {
        shouldStreamData ? "pause" : "play"
    }

    var balance: String {
        account?.currentEquity.currencyString ?? ""
    }

    var arrowImageName: String {
        dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
    }

    var subtitleColor: Color {
        return dayProfitLossPercentage > 0 ? .green : .red
    }

    var balanceSubTitle: String {
        guard dayProfitLossPercentage != 0, let initialEquity = account?.initialEquity, let currentLongMarginValue = account?.currentEquity else {
            return ""
        }
        let singleDayProfitLoss = initialEquity - currentLongMarginValue
        return "\(singleDayProfitLoss.currencyString) (\(dayProfitLossPercentage.twoDigitsFormatter)%)"
    }
}

// MARK: - SimpleStockView

extension AccountViewModel {
    var simpleStockRowViewModel: [SimpleStockRowViewModel] {
        simpleStockPositions
    }
}

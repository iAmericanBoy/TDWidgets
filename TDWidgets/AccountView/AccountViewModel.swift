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
    @Published private var lastUpdate: Date?
    @Published private var now = Date()

    private var timer: Timer?

    // MARK: init
    init(repository: Repository = RepositoryImpl()) {
        self.repository = repository
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateNow), userInfo: nil, repeats: true)
        getAccounts()
    }

    // MARK: Intent
    func getAccounts() {
        lastUpdate = Date()
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    if self.shouldStreamData {
                        self.getAccounts()
                    }
                }
            })
    }
}

// MARK: - AccountHeaderView

extension AccountViewModel {
    
    // MARK: Intents
    @objc
    func updateNow() {
        now = Date()
    }
    
    func streamData() {
        if shouldStreamData == false {
            getAccounts()
        }
        shouldStreamData.toggle()
    }

    //MARK: Variables    
    var timeIntervalString: String {
        guard let lastUpdateDate = lastUpdate else {
            return ""
        }
        let interval = now.timeIntervalSince(lastUpdateDate)
        if interval < 1  { return "loading" }
        return "\(lastUpdateDate.durationFormatter)"
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
        account?.dayProfitLossPercentage ?? 0 > 0 ? "arrow.up" : "arrow.down"
    }

    var subtitleColor: Color {
        return account?.dayProfitLossPercentage ?? 0 > 0 ? .green : .red
    }

    var balanceSubTitle: String {
        guard account?.dayProfitLossPercentage != 0, let initialEquity = account?.initialEquity, let currentLongMarginValue = account?.currentEquity else {
            return ""
        }
        let singleDayProfitLoss = initialEquity - currentLongMarginValue
        return "\(singleDayProfitLoss.currencyString) (\(account?.dayProfitLossPercentage.twoDigitsFormatter ?? "")%)"
    }
}

// MARK: - SimpleStockView

extension AccountViewModel {
    var simpleStockRowViewModel: [SimpleStockRowViewModel] {
        simpleStockPositions
    }
}

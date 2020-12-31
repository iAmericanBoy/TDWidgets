//
//  Account.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Foundation

struct Account {
    var type: String
    var accountID: String
    var initialEquity: Decimal
    var currentEquity: Decimal
    var positions: [Position]

    internal init(type: String, accountID: String, initialEquity: Decimal, currentEquity: Decimal, positions: [Position]) {
        self.type = type
        self.accountID = accountID
        self.initialEquity = initialEquity
        self.currentEquity = currentEquity
        self.positions = positions
    }

    init(_ accountElement: AccountElementDataModel) {
        type = accountElement.securitiesAccount.type
        accountID = accountElement.securitiesAccount.accountID
        initialEquity = accountElement.securitiesAccount.initialBalances.equity
        currentEquity = accountElement.securitiesAccount.currentBalances.equity
        positions = accountElement.securitiesAccount.positions?.compactMap { Position($0) } ?? []
    }

    var dayProfitLossPercentage: Decimal {
        return dayProfitLoss / initialEquity * 100
    }

    var dayProfitLoss: Decimal {
        return currentEquity - initialEquity
    }
}

extension Account {
    struct TestingVariation {
        static var completeMargin: Account {
            Account(type: "MARGIN", accountID: "123456", initialEquity: 55235, currentEquity: 59342, positions: [Position.TestingVariation.completeApple])
        }
    }
}

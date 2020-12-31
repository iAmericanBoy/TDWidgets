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

    internal init(type: String, accountID: String, initialEquity: Decimal, currentLongMarginValue: Decimal) {
        self.type = type
        self.accountID = accountID
        self.initialEquity = initialEquity
        currentEquity = currentLongMarginValue
    }

    init(_ accountElement: AccountElementDataModel) {
        type = accountElement.securitiesAccount.type
        accountID = accountElement.securitiesAccount.accountID
        initialEquity = accountElement.securitiesAccount.initialBalances.equity
        currentEquity = accountElement.securitiesAccount.currentBalances.equity
    }

    var dayProfitLossPercentage: Decimal {
        return dayProfitLoss / currentEquity * 100
    }

    var dayProfitLoss: Decimal {
        return initialEquity - currentEquity
    }
}

extension Account {
    struct TestingVariation {
        static var completeMargin: Account {
            Account(type: "MARGIN", accountID: "123456", initialEquity: 55235, currentLongMarginValue: 59342)
        }
    }
}

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
    var longMarginValue: Decimal
    var longMarginDifferenceValue: Decimal

    internal init(type: String, accountID: String, longMarginValue: Decimal, longMarginDifferenceValue: Decimal) {
        self.type = type
        self.accountID = accountID
        self.longMarginValue = longMarginValue
        self.longMarginDifferenceValue = longMarginDifferenceValue
    }

    init(_ accountElement: AccountElement) {
        type = accountElement.securitiesAccount.type
        accountID = accountElement.securitiesAccount.accountID
        longMarginValue = accountElement.securitiesAccount.currentBalances.longMarginValue
        longMarginDifferenceValue = accountElement.securitiesAccount.currentBalances.longMarginValue - accountElement.securitiesAccount.initialBalances.longMarginValue
    }
}

extension Account {
    struct TestingVariation {
        static var completeMargin: Account {
            Account(type: "Margin", accountID: "123456", longMarginValue: 17159.50, longMarginDifferenceValue: 8.58)
        }
    }
}

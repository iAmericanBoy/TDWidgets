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
    var longStockValue: Double
    var longStockDifference: Double
    
    internal init(type: String, accountID: String, longStockValue: Double, longStockDifference: Double) {
        self.type = type
        self.accountID = accountID
        self.longStockValue = longStockValue
        self.longStockDifference = longStockDifference
    }
    
    init(_ accountElement: AccountElement) {
        type = accountElement.securitiesAccount.type
        accountID = accountElement.securitiesAccount.accountID
        longStockValue = accountElement.securitiesAccount.currentBalances.longStockValue
        longStockDifference = accountElement.securitiesAccount.initialBalances.longStockValue - accountElement.securitiesAccount.currentBalances.longStockValue
    }
}


extension Account {
    struct TestingVariation {
        static var completeMargin: Account {
            Account(type: "Margin", accountID: "123456", longStockValue: 17159.50, longStockDifference: 8.58)
        }
    }
}

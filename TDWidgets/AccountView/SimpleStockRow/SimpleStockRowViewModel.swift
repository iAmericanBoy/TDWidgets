//
//  SimpleStockRowViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/28/20.
//

import SwiftUI

struct SimpleStockRowViewModel: Identifiable {
    var id: UUID = UUID()
    var symbol: String
    private var quanity: Decimal
    private var singleStockValue: Decimal
    private var dayProfitLossValue: Decimal
    private var dayProfitLossPercentage: Decimal

    var quanityString: String {
        "\(quanity.quanityString) Shares"
    }

    var marketValueString: String {
        singleStockValue.currencyString
    }

    var singleStockProfitLossString: String {
        if dayProfitLossPercentage == 0 { return "" }
        return "\(dayProfitLossValue.currencyString) (\(dayProfitLossPercentage.twoDigitsFormatter)%)"
    }

    var profitLossSymbol: String {
        if dayProfitLossPercentage == 0 { return "" }
        return dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
    }

    var profitLossColor: Color {
        return dayProfitLossPercentage > 0 ? .green : .red
    }

    internal init(id: UUID = UUID(), symbol: String, quanity: Decimal, singleStockValue: Decimal, dayProfitLossValue: Decimal, dayProfitLossPercentage: Decimal) {
        self.id = id
        self.symbol = symbol
        self.quanity = quanity
        self.singleStockValue = singleStockValue
        self.dayProfitLossValue = dayProfitLossValue
        self.dayProfitLossPercentage = dayProfitLossPercentage
    }

    init(_ position: Position) {
        symbol = position.symbol
        quanity = position.quanity
        singleStockValue = position.singleStockValue
        dayProfitLossValue = position.dayProfitLossValue
        dayProfitLossPercentage = position.dayProfitLossPercentage
    }
}

extension SimpleStockRowViewModel {
    struct TestingVariation {
        static var completeApple: SimpleStockRowViewModel {
            SimpleStockRowViewModel(symbol: "AAPL", quanity: 4.035, singleStockValue: 134.83, dayProfitLossValue: 3.36, dayProfitLossPercentage: 2.56)
        }
    }
}

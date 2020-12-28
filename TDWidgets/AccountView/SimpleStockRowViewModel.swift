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
    private var marketValue: Decimal
    private var totalDayProfitLoss: Decimal
    private var dayProfitLossPercentage: Decimal

    var quanityString: String {
        "\(quanity.quanityString) Shares"
    }

    var marketValueString: String {
        (marketValue / quanity).currencyString
    }

    var singleStockProfitLossString: String {
        if dayProfitLossPercentage == 0 { return "" }
        let singleStockProfitLoss = totalDayProfitLoss / quanity
        return "\(singleStockProfitLoss.currencyString) (\(dayProfitLossPercentage.twoDigitsFormatter)%)"
    }

    var profitLossSymbol: String {
        if dayProfitLossPercentage == 0 { return "" }
        return dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
    }

    var profitLossColor: Color {
        return dayProfitLossPercentage > 0 ? .green : .red
    }

    internal init(id: UUID = UUID(), symbol: String, quanity: Decimal, marketValue: Decimal, totalDayProfitLoss: Decimal, dayProfitLossPercentage: Decimal) {
        self.id = id
        self.symbol = symbol
        self.quanity = quanity
        self.marketValue = marketValue
        self.totalDayProfitLoss = totalDayProfitLoss
        self.dayProfitLossPercentage = dayProfitLossPercentage
    }

    init(_ position: PositionDataModel) {
        symbol = position.instrument.symbol
        quanity = position.longQuantity
        marketValue = position.marketValue
        totalDayProfitLoss = position.currentDayProfitLoss
        dayProfitLossPercentage = position.currentDayProfitLossPercentage
    }
}

extension SimpleStockRowViewModel {
    struct TestingVariation {
        static var completeApple: SimpleStockRowViewModel {
            SimpleStockRowViewModel(symbol: "AAPL", quanity: 4.035, marketValue: 134.83, totalDayProfitLoss: 3.36, dayProfitLossPercentage: 2.56)
        }
    }
}

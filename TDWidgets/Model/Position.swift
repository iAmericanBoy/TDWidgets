//
//  Position.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/31/20.
//

import Foundation

struct Position {
    var symbol: String
    var quanity: Decimal
    private var marketValue: Decimal
    private var totalDayProfitLoss: Decimal
    var dayProfitLossPercentage: Decimal

    internal init(symbol: String, quanity: Decimal, marketValue: Decimal, totalDayProfitLoss: Decimal, dayProfitLossPercentage: Decimal) {
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

    var singleStockValue: Decimal {
        marketValue / quanity
    }

    var dayProfitLossValue: Decimal {
        totalDayProfitLoss / quanity
    }
}

extension Position {
    struct TestingVariation {
        static var completeApple: Position {
            Position(symbol: "AAPL", quanity: 4.035, marketValue: 134.83, totalDayProfitLoss: 3.36, dayProfitLossPercentage: 2.56)
        }
    }
}

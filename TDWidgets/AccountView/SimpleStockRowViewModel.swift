//
//  SimpleStockRowViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/28/20.
//

import SwiftUI

struct SimpleStockRowViewModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var symbol: String
    private var quanity: Decimal
    private var marketValue: Decimal
    private var dayProfitLoss: Decimal
    private var dayProfitLossPercentage: Decimal

    var quanityString: String {
        "\(quanity.quanityString) Shares"
    }

    var marketValueString: String {
        marketValue.currencyString
    }

    var profitLossString: String {
        "\(dayProfitLoss.currencyString) (\(dayProfitLossPercentage)%)"
    }

    var profitLossSymbol: String {
        return dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
    }

    var profitLossColor: Color {
        return dayProfitLossPercentage > 0 ? .green : .red
    }

    internal init(id: UUID = UUID(), name: String, symbol: String, quanity: Decimal, marketValue: Decimal, dayProfitLoss: Decimal, dayProfitLossPercentage: Decimal) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.quanity = quanity
        self.marketValue = marketValue
        self.dayProfitLoss = dayProfitLoss
        self.dayProfitLossPercentage = dayProfitLossPercentage
    }

    init(_ position: PositionDataModel) {
        name = position.instrument.instrumentDescription ?? ""
        symbol = position.instrument.symbol
        quanity = position.longQuantity
        marketValue = position.marketValue
        dayProfitLoss = position.currentDayProfitLoss
        dayProfitLossPercentage = position.currentDayProfitLossPercentage
    }
}

extension SimpleStockRowViewModel {
    struct TestingVariation {
        static var completeApple: SimpleStockRowViewModel {
            SimpleStockRowViewModel(name: "Apple Inc.", symbol: "AAPL", quanity: 4.035, marketValue: 134.83, dayProfitLoss: 3.36, dayProfitLossPercentage: 2.56)
        }
    }
}

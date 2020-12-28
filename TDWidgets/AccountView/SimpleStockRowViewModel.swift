//
//  SimpleStockRowViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/28/20.
//

import Foundation

struct SimpleStockRowViewModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var symbol: String
    var marketValue: Decimal
    var dayProfitLoss: Decimal
    var dayProfitLossPercentage: Decimal

    internal init(name: String, symbol: String, marketValue: Decimal, dayProfitLoss: Decimal, dayProfitLossPercentage: Decimal) {
        self.name = name
        self.symbol = symbol
        self.marketValue = marketValue
        self.dayProfitLoss = dayProfitLoss
        self.dayProfitLossPercentage = dayProfitLossPercentage
    }

    init(_ position: PositionDataModel) {
        name = position.instrument.instrumentDescription ?? ""
        symbol = position.instrument.symbol
        marketValue = position.marketValue
        dayProfitLoss = position.currentDayProfitLoss
        dayProfitLossPercentage = position.currentDayProfitLossPercentage
    }
}

extension SimpleStockRowViewModel {
    struct TestingVariation {
        static var completeApple: SimpleStockRowViewModel {
            SimpleStockRowViewModel(name: "Apple Inc.", symbol: "AAPL", marketValue: 134.83, dayProfitLoss: 3.36, dayProfitLossPercentage: 2.56)
        }
    }
}

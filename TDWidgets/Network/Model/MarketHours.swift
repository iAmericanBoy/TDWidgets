//
//  MarketHours.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/5/21.
//

import Foundation

enum MarketType: String, Equatable {
    case equity
    case option
    case future
    case bond
    case forex
    case unknown
}

struct MarketHours {
    let marketType: MarketType
    let preMarket: (start: Date, end: Date)
    let regularMarket: (start: Date, end: Date)
    let postMarket: (start: Date, end: Date)

    internal init(marketType: MarketType, preMarket: (start: Date, end: Date), regularMarket: (start: Date, end: Date), postMarket: (start: Date, end: Date)) {
        self.marketType = marketType
        self.preMarket = preMarket
        self.regularMarket = regularMarket
        self.postMarket = postMarket
    }

    init(_ dataModel: MarketDataModel) {
        self.marketType = MarketType(rawValue: dataModel.equity.eq.marketType) ?? .unknown
        self.preMarket = (start: dataModel.equity.eq.sessionHours.preMarket[0].start, end: dataModel.equity.eq.sessionHours.preMarket[0].end)
        self.regularMarket = (start: dataModel.equity.eq.sessionHours.regularMarket[0].start, end: dataModel.equity.eq.sessionHours.regularMarket[0].end)
        self.postMarket = (start: dataModel.equity.eq.sessionHours.postMarket[0].start, end: dataModel.equity.eq.sessionHours.postMarket[0].end)
    }
}

extension MarketHours {
    struct TestingVariation {
        static var completeEquity: MarketHours {
            MarketHours(marketType: .equity,
                        preMarket: (start: Date(), end: Date()),
                        regularMarket: (start: Date(), end: Date()),
                        postMarket: (start: Date(), end: Date()))
        }
    }
}

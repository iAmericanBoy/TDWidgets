//
//  MarketHours.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/5/21.
//

import Foundation

enum MarketTypeError: Error {
    case parsingError
}

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

    init(_ dataModel: MarketDataModel) throws {
        self.marketType = MarketType(rawValue: dataModel.equity.eq.marketType) ?? .unknown

        guard let preStart = dataModel.equity.eq.sessionHours.preMarket[0].start.date,
            let preEnd = dataModel.equity.eq.sessionHours.preMarket[0].end.date,
            let regularStart = dataModel.equity.eq.sessionHours.regularMarket[0].start.date,
            let regularEnd = dataModel.equity.eq.sessionHours.regularMarket[0].end.date,
            let postStart = dataModel.equity.eq.sessionHours.postMarket[0].start.date,
            let postEnd = dataModel.equity.eq.sessionHours.postMarket[0].end.date else {
            throw MarketTypeError.parsingError
        }
        self.preMarket = (start: preStart, end: preEnd)
        self.regularMarket = (start: regularStart, end: regularEnd)
        self.postMarket = (start: postStart, end: postEnd)
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

private extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        return dateFormatter.date(from: self)
    }
}

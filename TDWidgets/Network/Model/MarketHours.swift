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

enum MarketType: String, Equatable, Codable {
    case equity = "EQUITY"
    case option
    case future
    case bond
    case forex
    case unknown
}

struct SessionHours: Codable {
    let start: Date
    let end: Date
}

struct MarketHours: Codable {
    let date: Date
    let marketType: MarketType
    let preMarket: DateInterval
    let regularMarket: DateInterval
    let postMarket: DateInterval

    internal init(date: Date = Date(), marketType: MarketType, preMarket: DateInterval, regularMarket: DateInterval, postMarket: DateInterval) {
        self.date = date
        self.marketType = marketType
        self.preMarket = preMarket
        self.regularMarket = regularMarket
        self.postMarket = postMarket
    }

    init(_ dataModel: MarketDataModel) throws {
        self.marketType = MarketType(rawValue: dataModel.equity.eq.marketType) ?? .unknown

        let preStart = dataModel.equity.eq.sessionHours.preMarket[0].start
        let preEnd = dataModel.equity.eq.sessionHours.preMarket[0].end
        let regularStart = dataModel.equity.eq.sessionHours.regularMarket[0].start
        let regularEnd = dataModel.equity.eq.sessionHours.regularMarket[0].end
        let postStart = dataModel.equity.eq.sessionHours.postMarket[0].start
        let postEnd = dataModel.equity.eq.sessionHours.postMarket[0].end

        self.preMarket = DateInterval(start: preStart, end: preEnd)
        self.regularMarket = DateInterval(start: regularStart, end: regularEnd)
        self.postMarket = DateInterval(start: postStart, end: postEnd)
        self.date = Date()
    }
}

extension MarketHours {
    struct TestingVariation {
        static var completeEquity: MarketHours {
            MarketHours(marketType: .equity,
                        preMarket: DateInterval(start: Date(), end: Date()),
                        regularMarket: DateInterval(start: Date(), end: Date()),
                        postMarket: DateInterval(start: Date(), end: Date()))
        }
    }
}

private extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        return dateFormatter.date(from: self)
    }
}

//
//  AccountEntry.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

struct AccountEntry: TimelineEntry {
    let date: Date
    let dateText: String

    let dayProfitLossText: String
    let dayProfitLossColor: Color
    let dayProfitLossImage: String

    let sessionTypeColor: Color
    let isSessionTypeClosed: Bool

    let row1: [GridValue]
    let row2: [GridValue]

    let isError: Bool

    internal init(date: Date, dateText: String, dayProfitLossText: String, dayProfitLossColor: Color, dayProfitLossImage: String, sessionTypeColor: Color, isSessionTypeClosed: Bool, row1: [GridValue], row2: [GridValue], isError: Bool) {
        self.date = date
        self.dateText = dateText
        self.dayProfitLossText = dayProfitLossText
        self.dayProfitLossColor = dayProfitLossColor
        self.dayProfitLossImage = dayProfitLossImage
        self.sessionTypeColor = sessionTypeColor
        self.isSessionTypeClosed = isSessionTypeClosed
        self.row1 = row1
        self.row2 = row2
        self.isError = isError
    }

    init(_ account: Account, sessionType: MarketSessionType) {
        date = Date()
        dateText = sessionType == .closed ? "closed" : "ago"
        if sessionType == .closed {
            dayProfitLossText = "\(account.dayProfitLoss.currencyString)"
        } else {
            dayProfitLossText = "\(account.dayProfitLossPercentage.twoDigitsFormatter)%"
        }
        dayProfitLossImage = account.dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
        dayProfitLossColor = account.dayProfitLossPercentage > 0 ? .green : .red
        switch sessionType {
        case .pre:
            sessionTypeColor = Colors.morningOrange
        case .regular:
            sessionTypeColor = Colors.oliveGreen
        case .post:
            sessionTypeColor = Colors.nightPurple
        case .closed:
            sessionTypeColor = .black
        }
        isSessionTypeClosed = sessionType == .closed

        var array = account.positions.map { GridValue(symbol: $0.symbol,
                                                      percentage: $0.dayProfitLossPercentage,
                                                      amount: $0.dayProfitLossValue,
                                                      isClosed: sessionType == .closed) }

        array.sort(by: >)

        let best = array.removeFirst()
        let secondbest = array.removeFirst()
        let worst = array.removeLast()
        let secondWorst = array.removeLast()
        row1 = [best, secondbest]
        row2 = [secondWorst, worst]
        isError = false
    }

    struct GridValue: Comparable {
        static func < (lhs: AccountEntry.GridValue, rhs: AccountEntry.GridValue) -> Bool {
            return lhs.percentage < rhs.percentage
        }

        var symbol: String
        private var percentage: Decimal
        private var amount: Decimal
        private var isClosed: Bool

        init(symbol: String, percentage: Decimal, amount: Decimal, isClosed: Bool) {
            self.symbol = symbol
            self.percentage = percentage
            self.amount = amount
            self.isClosed = isClosed
        }

        var arrowName: String {
            percentage > 0 ?"arrow.up" : "arrow.down"
        }

        var string: String {
            isClosed ? "\(amount.currencyString)" : "\(percentage.twoDigitsFormatter)%"
        }

        var color: Color {
            percentage > 0 ? .green : .red
        }
    }
}

extension AccountEntry {
    struct TestingVariation {
        static func updated(_ currentDate: Date) -> AccountEntry {
            AccountEntry(date: currentDate,
                         dateText: "ago",
                         dayProfitLossText: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.morningOrange,
                         isSessionTypeClosed: false,
                         row1: [GridValue(symbol: "AAPL",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false),
                                GridValue(symbol: "MSFT",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false)],
                         row2: [GridValue(symbol: "VOO",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false),
                                GridValue(symbol: "BYND",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false)],
                         isError: false)
        }

        static var complete: AccountEntry {
            AccountEntry(date: Date(),
                         dateText: "ago",
                         dayProfitLossText: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.nightPurple,
                         isSessionTypeClosed: false,
                         row1: [GridValue(symbol: "AAPL",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false),
                                GridValue(symbol: "MSFT",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false)],
                         row2: [GridValue(symbol: "VOO",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false),
                                GridValue(symbol: "BYND",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false)],
                         isError: false)
        }

        static var closedComplete: AccountEntry {
            AccountEntry(date: Date(),
                         dateText: "closed",
                         dayProfitLossText: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: .black,
                         isSessionTypeClosed: true,
                         row1: [GridValue(symbol: "AAPL",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: true),
                                GridValue(symbol: "MSFT",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: true)],
                         row2: [GridValue(symbol: "VOO",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: true),
                                GridValue(symbol: "BYND",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: true)],
                         isError: false)
        }

        static var openComplete: AccountEntry {
            AccountEntry(date: Date(),
                         dateText: "ago",
                         dayProfitLossText: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.oliveGreen,
                         isSessionTypeClosed: false,
                         row1: [GridValue(symbol: "AAPL",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false),
                                GridValue(symbol: "MSFT",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false)],
                         row2: [GridValue(symbol: "VOO",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false),
                                GridValue(symbol: "BYND",
                                          percentage: 2.02,
                                          amount: 10.01,
                                          isClosed: false)],
                         isError: false)
        }
    }

    struct SnapshotVariation {
        static var complete: AccountEntry {
            AccountEntry(date: Date(), dateText: "closed", dayProfitLossText: "3.14%", dayProfitLossColor: .green, dayProfitLossImage: "arrow.up", sessionTypeColor: .black, isSessionTypeClosed: false, row1: [], row2: [], isError: false)
        }

        static var error: AccountEntry {
            AccountEntry(date: Date(), dateText: "", dayProfitLossText: "", dayProfitLossColor: .green, dayProfitLossImage: "", sessionTypeColor: .black, isSessionTypeClosed: false, row1: [], row2: [], isError: true)
        }
    }
}

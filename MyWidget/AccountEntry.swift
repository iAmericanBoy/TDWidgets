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
    let dayProfitLossPercentage: String
    let dayProfitLossColor: Color
    let dayProfitLossImage: String
    let sessionTypeColor: Color
    let isSessionTypeClosed: Bool
    let row1: [GridValue]
    let row2: [GridValue]

    internal init(date: Date, dateText: String, dayProfitLossValue: String, dayProfitLossColor: Color, dayProfitLossImage: String, sessionTypeColor: Color, isSessionTypeClosed: Bool, row1: [GridValue], row2: [GridValue]) {
        self.date = date
        self.dateText = dateText
        dayProfitLossPercentage = dayProfitLossValue
        self.dayProfitLossColor = dayProfitLossColor
        self.dayProfitLossImage = dayProfitLossImage
        self.sessionTypeColor = sessionTypeColor
        self.isSessionTypeClosed = isSessionTypeClosed
        self.row1 = row1
        self.row2 = row2
    }

    init(_ account: Account, sessionType: MarketSessionType) {
        date = Date()
        dateText = sessionType == .closed ? "closed" : "ago"
        dayProfitLossPercentage = "\(account.dayProfitLossPercentage.twoDigitsFormatter)%"
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

        var array = account.positions.map { GridValue(symbol: $0.symbol, percentage: $0.dayProfitLossPercentage) }

        array.sort(by: { $0.percentage > $1.percentage })

        let best = array.removeFirst()
        let secondbest = array.removeFirst()
        let worst = array.removeLast()
        let secondWorst = array.removeLast()
        row1 = [best, secondbest]
        row2 = [secondWorst, worst]
    }

    struct GridValue {
        var symbol: String
        var percentage: Decimal

        init(symbol: String, percentage: Decimal) {
            self.symbol = symbol
            self.percentage = percentage
        }

        var arrowName: String {
            percentage > 0 ?"arrow.up" : "arrow.down"
        }

        var percentageString: String {
            "\(percentage.twoDigitsFormatter)%"
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
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.morningOrange,
                         isSessionTypeClosed: false,
                         row1: [GridValue(symbol: "AAPL", percentage: 2.02),
                                GridValue(symbol: "MSFT", percentage: 2.02)],
                         row2: [GridValue(symbol: "VOO", percentage: 2.02),
                                GridValue(symbol: "BYND", percentage: 2.02)])
        }

        static var complete: AccountEntry {
            AccountEntry(date: Date(),
                         dateText: "ago",
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.nightPurple,
                         isSessionTypeClosed: false,
                         row1: [GridValue(symbol: "AAPL", percentage: 2.02),
                                GridValue(symbol: "MSFT", percentage: 2.02)],
                         row2: [GridValue(symbol: "VOO", percentage: 2.02),
                                GridValue(symbol: "BYND", percentage: 2.02)])
        }

        static var closedComplete: AccountEntry {
            AccountEntry(date: Date(),
                         dateText: "closed",
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: .black,
                         isSessionTypeClosed: true,
                         row1: [GridValue(symbol: "AAPL", percentage: 2.02),
                                GridValue(symbol: "MSFT", percentage: 2.02)],
                         row2: [GridValue(symbol: "VOO", percentage: 2.02),
                                GridValue(symbol: "BYND", percentage: 2.02)])
        }

        static var openComplete: AccountEntry {
            AccountEntry(date: Date(),
                         dateText: "ago",
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.oliveGreen,
                         isSessionTypeClosed: false,
                         row1: [GridValue(symbol: "AAPL", percentage: 2.02),
                                GridValue(symbol: "MSFT", percentage: 2.02)],
                         row2: [GridValue(symbol: "VOO", percentage: 2.02),
                                GridValue(symbol: "BYND", percentage: 2.02)])
        }
    }

    struct SnapshotVariation {
        static var complete: AccountEntry {
            AccountEntry(date: Date(), dateText: "closed", dayProfitLossValue: "3.14%", dayProfitLossColor: .green, dayProfitLossImage: "arrow.up", sessionTypeColor: .black, isSessionTypeClosed: false, row1: [], row2: [])
        }
    }
}

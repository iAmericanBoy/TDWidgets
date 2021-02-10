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
    let dayProfitLossPercentage: String
    let dayProfitLossColor: Color
    let dayProfitLossImage: String
    let sessionTypeColor: Color
    let row1: [GridValue]
    let row2: [GridValue]

    internal init(date: Date, dayProfitLossValue: String, dayProfitLossColor: Color, dayProfitLossImage: String, sessionTypeColor: Color, row1: [GridValue], row2: [GridValue]) {
        self.date = date
        dayProfitLossPercentage = dayProfitLossValue
        self.dayProfitLossColor = dayProfitLossColor
        self.dayProfitLossImage = dayProfitLossImage
        self.sessionTypeColor = sessionTypeColor
        self.row1 = row1
        self.row2 = row2
    }

    init(_ account: Account, sessionType: MarketSessionType) {
        date = Date()
        dayProfitLossPercentage = "\(account.dayProfitLossPercentage.twoDigitsFormatter)%"
        dayProfitLossImage = account.dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
        dayProfitLossColor = account.dayProfitLossPercentage > 0 ? .green : .red
        sessionTypeColor = .black

        var array = account.positions.map { GridValue(symbol: $0.symbol, percentage: $0.dayProfitLossPercentage) }

        let first = array.removeFirst()
        let second = array.removeFirst()
        let third = array.removeFirst()
        let fourth = array.removeFirst()
        row1 = [first, second]
        row2 = [third, fourth]
    }

    struct GridValue {
        var symbol: String
        private var percentage: Decimal

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
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.morningOrange,
                         row1: [GridValue(symbol: "AAPL", percentage: 2.02),
                                GridValue(symbol: "MSFT", percentage: 2.02)],
                         row2: [GridValue(symbol: "VOO", percentage: 2.02),
                                GridValue(symbol: "BYND", percentage: 2.02)])
        }

        static var complete: AccountEntry {
            AccountEntry(date: Date(),
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         sessionTypeColor: Colors.nightPurple,
                         row1: [GridValue(symbol: "AAPL", percentage: 2.02),
                                GridValue(symbol: "MSFT", percentage: 2.02)],
                         row2: [GridValue(symbol: "VOO", percentage: 2.02),
                                GridValue(symbol: "BYND", percentage: 2.02)])
        }
    }

    struct SnapshotVariation {
        static var complete: AccountEntry {
            AccountEntry(date: Date(), dayProfitLossValue: "3.14%", dayProfitLossColor: .green, dayProfitLossImage: "arrow.up", sessionTypeColor: .black, row1: [], row2: [])
        }
    }
}

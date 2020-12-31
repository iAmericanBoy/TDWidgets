//
//  AccountEntry.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

typealias GridValue = (symbol: String, arrowName: String, percentageString: String, color: Color)

struct AccountEntry: TimelineEntry {
    let date: Date
    let dayProfitLossPercentage: String
    let dayProfitLossColor: Color
    let dayProfitLossImage: String
    let row1: [GridValue]
    let row2: [GridValue]

    internal init(date: Date, dayProfitLossValue: String, dayProfitLossColor: Color, dayProfitLossImage: String, row1: [GridValue], row2: [GridValue]) {
        self.date = date
        dayProfitLossPercentage = dayProfitLossValue
        self.dayProfitLossColor = dayProfitLossColor
        self.dayProfitLossImage = dayProfitLossImage
        self.row1 = row1
        self.row2 = row2
    }

    init(_ account: Account) {
        date = Date()
        dayProfitLossPercentage = "\(account.dayProfitLossPercentage.twoDigitsFormatter)%"
        dayProfitLossImage = account.dayProfitLossPercentage > 0 ? "arrow.up" : "arrow.down"
        dayProfitLossColor = account.dayProfitLossPercentage > 0 ? .green : .red
        row1 = []
        row2 = []
    }
}

extension AccountEntry {
    struct TestingVariation {
        static func updated(_ currentDate: Date) -> AccountEntry {
            AccountEntry(date: currentDate,
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         row1: [(symbol: "AAPL",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green),
                                (symbol: "MSFT",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green)],
                         row2: [(symbol: "VOO",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green),
                                (symbol: "BYND",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green)])
        }

        static var complete: AccountEntry {
            AccountEntry(date: Date(),
                         dayProfitLossValue: "3.14%",
                         dayProfitLossColor: .green,
                         dayProfitLossImage: "arrow.up",
                         row1: [(symbol: "AAPL",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green),
                                (symbol: "MSFT",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green)],
                         row2: [(symbol: "VOO",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green),
                                (symbol: "BYND",
                                 arrowName: "arrow.up",
                                 percentageString: "2.02%",
                                 color: .green)])
        }
    }

    struct SnapshotVariation {
        static var complete: AccountEntry {
            AccountEntry(date: Date(), dayProfitLossValue: "3.14%", dayProfitLossColor: .green, dayProfitLossImage: "arrow.up", row1: [], row2: [])
        }
    }
}

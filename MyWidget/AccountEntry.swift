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
    let dayProfitLossValue: String
    let dayProfitLossColor: Color
    let dayProfitLossImage: String
    let row1: [GridValue]
    let row2: [GridValue]
}

extension AccountEntry {
    struct TestingVariation {
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
}

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
    let dayProfitLossPercentageValue: String
}

extension AccountEntry {
    struct TestingVariation {
        static var complete: AccountEntry {
            AccountEntry(date: Date(), dayProfitLossPercentageValue: "3.14 %")
        }
    }
}

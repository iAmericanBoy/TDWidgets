//
//  Numberformatter.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/28/20.
//

import Foundation

extension Decimal {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        let decimal: NSDecimalNumber = NSDecimalNumber(decimal: self)
        return formatter.string(from: decimal) ?? ""
    }

    var quanityString: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        let decimal: NSDecimalNumber = NSDecimalNumber(decimal: self)
        return formatter.string(from: decimal) ?? ""
    }

    var twoDigitsFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let decimal: NSDecimalNumber = NSDecimalNumber(decimal: self)
        return formatter.string(from: decimal) ?? ""
    }
}

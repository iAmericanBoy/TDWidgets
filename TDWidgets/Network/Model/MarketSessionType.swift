//
//  MarketSessionType.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/13/21.
//

import Foundation

enum MarketSessionType {
    case pre
    case regular
    case post
    case closed
}

extension MarketSessionType {
    init(_ marketHours: MarketHours) {
        let currentDate = Date()
        if marketHours.preMarket.contains(currentDate) {
            self = .pre
        } else if marketHours.regularMarket.contains(currentDate) {
            self = .regular
        } else if marketHours.postMarket.contains(currentDate) {
            self = .post
        } else {
            self = .closed
        }
    }
}

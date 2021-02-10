//
//  MarketHourIconViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 2/9/21.
//

import SwiftUI

struct MarketHourIconViewModel {
    private let type: MarketSessionType
    init(_ sessionType: MarketSessionType) {
        self.type = sessionType
    }

    var title: String {
        switch type {
        case .pre:
            return "pre market"
        case .regular:
            return "open"
        case .closed:
            return ""
        case .post:
            return "post market"
        }
    }

    var color: Color {
        switch type {
        case .pre:
            return Colors.morningOrange
        case .regular:
            return Colors.oliveGreen
        case .closed:
            return Colors.white
        case .post:
            return Colors.nightPurple
        }
    }
}

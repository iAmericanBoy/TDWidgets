//
//  MarketHourIconViewModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 2/9/21.
//

import SwiftUI

extension MarketSessionType {
    var title: String {
        switch self {
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
        switch self {
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

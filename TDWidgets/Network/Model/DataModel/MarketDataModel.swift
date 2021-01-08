//
//  MarketDataModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/5/21.
//

import Foundation

// MARK: MarketDataModel

struct MarketDataModel: Codable {
    let equity: EquityDataModel
}

// MARK: EquityDataModel

struct EquityDataModel: Codable {
    let eq: EqDataModel

    enum CodingKeys: String, CodingKey {
        case eq = "EQ"
    }
}

// MARK: EqDataModel

struct EqDataModel: Codable {
    let date, marketType, exchange, category: String
    let product, productName: String
    let isOpen: Bool
    let sessionHours: SessionHoursDataModel
}

// MARK: SessionHoursDataModel

struct SessionHoursDataModel: Codable {
    let preMarket, regularMarket, postMarket: [MarketHoursDataModel]
}

// MARK: MarketHoursDataModel

struct MarketHoursDataModel: Codable {
    let start, end: String
}

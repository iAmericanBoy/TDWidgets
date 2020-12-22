//
//  AccountDataModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Foundation

import Foundation

typealias AccountDataModel = [AccountElement]

// MARK: - AccountElement
struct AccountElement: Codable {
    let securitiesAccount: SecuritiesAccount
}

// MARK: - SecuritiesAccount
struct SecuritiesAccount: Codable {
    let type, accountID: String
    let roundTrips: Int
    let isDayTrader, isClosingOnlyRestricted: Bool
    let positions: [Position]
    let initialBalances: Balances
    let currentBalances: Balances
    let projectedBalances: ProjectedBalances

    enum CodingKeys: String, CodingKey {
        case type
        case accountID = "accountId"
        case roundTrips, isDayTrader, isClosingOnlyRestricted, positions, initialBalances, currentBalances, projectedBalances
    }
}

// MARK: - Balances
struct Balances: Codable {
    let accruedInterest: Int
    let availableFundsNonMarginableTrade: Double
    let bondValue: Int
    let buyingPower: Double
    let cashBalance, cashAvailableForTrading, cashReceipts, dayTradingBuyingPower: Int
    let dayTradingBuyingPowerCall, dayTradingEquityCall: Int
    let equity, equityPercentage, liquidationValue, longMarginValue: Double
    let longOptionMarketValue: Int
    let longStockValue: Double
    let maintenanceCall: Int
    let maintenanceRequirement, margin, marginEquity: Double
    let moneyMarketFund: Int
    let mutualFundValue: Double
    let regTCall, shortMarginValue, shortOptionMarketValue, shortStockValue: Int
    let totalCash: Double
    let isInCall: Bool
    let pendingDeposits: Int
    let marginBalance: Double
    let shortBalance: Int
    let accountValue: Double
}

// MARK: - Position
struct Position: Codable {
    let shortQuantity: Int
    let averagePrice, currentDayProfitLoss, currentDayProfitLossPercentage, longQuantity: Double
    let settledLongQuantity: Double
    let settledShortQuantity: Int
    let instrument: Instrument
    let marketValue: Double
    let agedQuantity: Double?
}

// MARK: - Instrument
struct Instrument: Codable {
    let assetType, cusip, symbol: String
    let instrumentDescription: String?

    enum CodingKeys: String, CodingKey {
        case assetType, cusip, symbol
        case instrumentDescription = "description"
    }
}

// MARK: - ProjectedBalances
struct ProjectedBalances: Codable {
    let availableFunds, availableFundsNonMarginableTrade, buyingPower: Double
    let dayTradingBuyingPower, dayTradingBuyingPowerCall, maintenanceCall, regTCall: Int
    let isInCall: Bool
    let stockBuyingPower: Double
}


//
//  AccountDataModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Foundation

import Foundation

typealias AccountDataModel = [AccountElementDataModel]

// MARK: - AccountElementDataModel

struct AccountElementDataModel: Codable {
    let securitiesAccount: SecuritiesAccountDataModel
}

// MARK: - SecuritiesAccountDataModel

struct SecuritiesAccountDataModel: Codable {
    let type, accountID: String
    let roundTrips: Int
    let isDayTrader, isClosingOnlyRestricted: Bool
    let positions: [PositionDataModel]?
    let initialBalances: InitialBalancesDataModel
    let currentBalances: CurrentBalancesDataModel
    let projectedBalances: ProjectedBalancesDataModel

    enum CodingKeys: String, CodingKey {
        case type
        case accountID = "accountId"
        case roundTrips, isDayTrader, isClosingOnlyRestricted, positions, initialBalances, currentBalances, projectedBalances
    }
}

// MARK: - InitialBalancesDataModel

struct InitialBalancesDataModel: Codable {
    let accruedInterest: Decimal
    let availableFundsNonMarginableTrade: Decimal
    let bondValue: Decimal
    let buyingPower: Decimal
    let cashBalance, cashAvailableForTrading, cashReceipts, dayTradingBuyingPower: Decimal
    let dayTradingBuyingPowerCall, dayTradingEquityCall: Decimal
    let equity, equityPercentage, liquidationValue, longMarginValue: Decimal
    let longOptionMarketValue: Decimal
    let longStockValue: Decimal
    let maintenanceCall: Decimal
    let maintenanceRequirement, margin, marginEquity: Decimal
    let moneyMarketFund: Decimal
    let mutualFundValue: Decimal
    let regTCall, shortMarginValue, shortOptionMarketValue, shortStockValue: Decimal
    let totalCash: Decimal
    let isInCall: Bool
    let pendingDeposits: Decimal
    let marginBalance: Decimal
    let shortBalance: Decimal
    let accountValue: Decimal
}

// MARK: - CurrentBalancesDataModel

struct CurrentBalancesDataModel: Codable {
    let accruedInterest, cashBalance, cashReceipts, longOptionMarketValue: Decimal
    let liquidationValue, longMarketValue: Decimal
    let moneyMarketFund, savings, shortMarketValue, pendingDeposits: Decimal
    let availableFunds: Decimal
    let availableFundsNonMarginableTrade, buyingPower, buyingPowerNonMarginableTrade: Decimal
    let dayTradingBuyingPower: Decimal
    let equity: Decimal
    let equityPercentage: Decimal
    let longMarginValue: Decimal
    let maintenanceCall: Decimal
    let maintenanceRequirement, marginBalance: Decimal
    let regTCall, shortBalance, shortMarginValue, shortOptionMarketValue: Decimal
    let sma, mutualFundValue: Decimal
    let bondValue: Decimal
}

// MARK: - PositionDataModel

struct PositionDataModel: Codable {
    let shortQuantity: Int
    let averagePrice, currentDayProfitLoss, currentDayProfitLossPercentage, longQuantity: Decimal
    let settledLongQuantity: Decimal
    let settledShortQuantity: Int
    let instrument: InstrumentDataModel
    let marketValue: Decimal
    let agedQuantity: Decimal?
}

// MARK: - InstrumentDataModel

struct InstrumentDataModel: Codable {
    let assetType, cusip, symbol: String
    let instrumentDescription: String?

    enum CodingKeys: String, CodingKey {
        case assetType, cusip, symbol
        case instrumentDescription = "description"
    }
}

// MARK: - ProjectedBalancesDataModel

struct ProjectedBalancesDataModel: Codable {
    let availableFunds, availableFundsNonMarginableTrade, buyingPower: Double
    let dayTradingBuyingPower, dayTradingBuyingPowerCall, maintenanceCall, regTCall: Int
    let isInCall: Bool
    let stockBuyingPower: Double
}

extension AccountDataModel {
    struct TestingVariation {
        static var complete: AccountDataModel {
            [AccountElementDataModel(securitiesAccount: SecuritiesAccountDataModel(type: "Margin",
                                                                                   accountID: "12345",
                                                                                   roundTrips: 0,
                                                                                   isDayTrader: false,
                                                                                   isClosingOnlyRestricted: false,
                                                                                   positions: [PositionDataModel(shortQuantity: 0, averagePrice: 0, currentDayProfitLoss: 2.75, currentDayProfitLossPercentage: 1.24, longQuantity: 12.093, settledLongQuantity: 0, settledShortQuantity: 0, instrument: InstrumentDataModel(assetType: "", cusip: "", symbol: "MSFT", instrumentDescription: ""), marketValue: 225.33, agedQuantity: 0),
                                                                                               PositionDataModel(shortQuantity: 0, averagePrice: 0, currentDayProfitLoss: 3.86, currentDayProfitLossPercentage: 2.94, longQuantity: 4.035, settledLongQuantity: 0, settledShortQuantity: 0, instrument: InstrumentDataModel(assetType: "", cusip: "", symbol: "AAPL", instrumentDescription: ""), marketValue: 135.83, agedQuantity: 0),
                                                                                               PositionDataModel(shortQuantity: 0, averagePrice: 0, currentDayProfitLoss: -8, currentDayProfitLossPercentage: -5.88, longQuantity: 21, settledLongQuantity: 0, settledShortQuantity: 0, instrument: InstrumentDataModel(assetType: "", cusip: "", symbol: "BYND", instrumentDescription: ""), marketValue: 128.28, agedQuantity: 0),
                                                                                               PositionDataModel(shortQuantity: 0, averagePrice: 0, currentDayProfitLoss: 2.68, currentDayProfitLossPercentage: 0.79, longQuantity: 2.019, settledLongQuantity: 0, settledShortQuantity: 0, instrument: InstrumentDataModel(assetType: "", cusip: "", symbol: "VOO", instrumentDescription: ""), marketValue: 341.82, agedQuantity: 0),
                                                                                               PositionDataModel(shortQuantity: 0, averagePrice: 0, currentDayProfitLoss: 0.47, currentDayProfitLossPercentage: 0.36, longQuantity: 9.3, settledLongQuantity: 0, settledShortQuantity: 0, instrument: InstrumentDataModel(assetType: "", cusip: "", symbol: "FXAIX", instrumentDescription: ""), marketValue: 128.31, agedQuantity: 0)],
                                                                                   initialBalances: InitialBalancesDataModel(accruedInterest: 0, availableFundsNonMarginableTrade: 0, bondValue: 0, buyingPower: 0, cashBalance: 0, cashAvailableForTrading: 0, cashReceipts: 0, dayTradingBuyingPower: 0, dayTradingBuyingPowerCall: 0, dayTradingEquityCall: 0, equity: 0, equityPercentage: 0, liquidationValue: 0, longMarginValue: 7399.99, longOptionMarketValue: 0, longStockValue: 0, maintenanceCall: 0, maintenanceRequirement: 0, margin: 0, marginEquity: 0, moneyMarketFund: 0, mutualFundValue: 0, regTCall: 0, shortMarginValue: 0, shortOptionMarketValue: 0, shortStockValue: 0, totalCash: 0, isInCall: false, pendingDeposits: 0, marginBalance: 0, shortBalance: 0, accountValue: 0),
                                                                                   currentBalances: CurrentBalancesDataModel(accruedInterest: 0, cashBalance: 0, cashReceipts: 0, longOptionMarketValue: 0, liquidationValue: 0, longMarketValue: 0, moneyMarketFund: 0, savings: 0, shortMarketValue: 0, pendingDeposits: 0, availableFunds: 0, availableFundsNonMarginableTrade: 0, buyingPower: 0, buyingPowerNonMarginableTrade: 0, dayTradingBuyingPower: 0, equity: 0, equityPercentage: 0, longMarginValue: 7428.09, maintenanceCall: 0, maintenanceRequirement: 0, marginBalance: 0, regTCall: 0, shortBalance: 0, shortMarginValue: 0, shortOptionMarketValue: 0, sma: 0, mutualFundValue: 0, bondValue: 0),
                                                                                   projectedBalances: ProjectedBalancesDataModel(availableFunds: 0, availableFundsNonMarginableTrade: 0, buyingPower: 0, dayTradingBuyingPower: 0, dayTradingBuyingPowerCall: 0, maintenanceCall: 0, regTCall: 0, isInCall: false, stockBuyingPower: 0)))]
        }
    }
}

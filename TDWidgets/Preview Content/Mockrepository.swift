//
//  Mockrepository.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Combine
import Foundation

class MockRepositry: Repository {
    var marketSessionAppModelValue: MarketSessionType!
    func getCurrentMarketHourType() -> AnyPublisher<MarketSessionType, Never> {
        let mockResult: Result<MarketSessionType, Never> = .success(marketSessionAppModelValue)
        return mockResult.publisher.eraseToAnyPublisher()
    }
    
    var marketHoursAppModelValue: MarketHours!
    func getCurrentMarketHours() -> AnyPublisher<MarketHours, Error> {
        let mockResult: Result<MarketHours, Error> = .success(marketHoursAppModelValue)
        return mockResult.publisher.eraseToAnyPublisher()
    }

    var accountAppModelValue: [Account]!
    func getAccouts() -> AnyPublisher<[Account], Error> {
        let mockResult: Result<[Account], Error> = .success(accountAppModelValue)
        return mockResult.publisher.eraseToAnyPublisher()
    }
}

extension MockRepositry {
    struct PreviewVariation {
        static var complete: Repository {
            let mock = MockRepositry()
            mock.accountAppModelValue = [Account.TestingVariation.completeMargin]
            mock.marketHoursAppModelValue = MarketHours.TestingVariation.completeEquity
            return mock
        }
    }
}

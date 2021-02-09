//
//  Repository.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

// the repositorys job is to be a single point of entry to the service that powers the app
// it takes a datamodel and converts it to the appmodel but also would be in charge of caching and saving data for later use
// it should also take errors form the datastore and handle them gracefully or populate to the view layers of the app

import Combine
import Foundation

enum RepositoryError: Error {
    case urlComponents
}

protocol Repository {
    func getAccouts() -> AnyPublisher<[Account], Error>
    func getCurrentMarketHours() -> AnyPublisher<MarketHours, Error>
    func getCurrentMarketHourType() -> AnyPublisher<MarketSessionType, Never>
}

class RepositoryImpl: Repository {
    private let dataStore: DataStore

    init(dataStore: DataStore = DataStoreImpl()) {
        self.dataStore = dataStore
    }

    // MARK: MarketHourType

    func getCurrentMarketHourType() -> AnyPublisher<MarketSessionType, Never> {
        getCurrentMarketHours()
            .map { MarketSessionType($0) }
            .replaceError(with: .closed)
            .eraseToAnyPublisher()
    }

    func getCurrentMarketHours() -> AnyPublisher<MarketHours, Error> {
        if let savedHours = UserDefaults(suiteName: "group.com.oskman.WidgetGroup")?.object(forKey: "Repository.marketHours") as? Data {
            let decoder = JSONDecoder()
            if let hours = try? decoder.decode(MarketHours.self, from: savedHours), Calendar.current.isDateInToday(hours.date) {
                return Just(hours)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dataStore.getMarketHours(for: dateFormater.string(from: Date()))
            .tryMap { dataModel in
                try MarketHours(dataModel)
            }
            .handleEvents(receiveOutput: { hours in
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(hours) {
                    UserDefaults(suiteName: "group.com.oskman.WidgetGroup")?.set(encoded, forKey: "Repository.marketHours")
                }
            })
            .eraseToAnyPublisher()
    }

    // MARK: Accounts

    func getAccouts() -> AnyPublisher<[Account], Error> {
        return dataStore.getAccouts()
            .map { dataModel in
                dataModel.map { Account($0) }
            }
            .eraseToAnyPublisher()
    }
}

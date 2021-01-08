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
    func getMarketHours() -> AnyPublisher<MarketHours, Error>
}

class RepositoryImpl: Repository {
    private let dataStore: DataStore

    init(dataStore: DataStore = DataStoreImpl()) {
        self.dataStore = dataStore
    }

    func getMarketHours() -> AnyPublisher<MarketHours, Error> {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dataStore.getMarketHours(for: dateFormater.string(from: Date()))
            .tryMap { dataModel in
                try MarketHours(dataModel)
            }
            .eraseToAnyPublisher()
    }

    func getAccouts() -> AnyPublisher<[Account], Error> {
        return dataStore.getAccouts()
            .map { dataModel in
                dataModel.map { Account($0) }
            }
            .eraseToAnyPublisher()
    }
}

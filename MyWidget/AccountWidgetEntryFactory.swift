//
//  AccountWidgetEntryFactory.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import Combine
import Foundation

enum FactoryError: Error {
    case noAccount
}

class AccountWidgetEntryFactory {
    // MARK: Members:

    private let repository: Repository

    // MARK: Subscribers:

    private var entrySubscriber: AnyCancellable?

    init(repository: Repository = RepositoryImpl()) {
        self.repository = repository
    }

    func createEntry(completion: @escaping (Result<AccountEntry, Error>) -> Void) {
        entrySubscriber = repository.getAccouts()
            .map { dataModel -> Result<Account, Error> in
                if let firstAccount = dataModel.first {
                    return .success(firstAccount)
                } else {
                    return .failure(FactoryError.noAccount)
                }
            }
            .zip(repository.getCurrentMarketHourType().setFailureType(to: Error.self))
            .receive(on: RunLoop.main)
            .map { (firstAccountResponse, sessionType) -> Result<AccountEntry, Error> in
                switch firstAccountResponse {
                case .success(let firstAccount):
                    return .success(AccountEntry(firstAccount, sessionType: sessionType))
                case .failure(let error):
                    return .failure(error)
                }
            }
            .sink(receiveCompletion: { finishedCompletion in
                print(finishedCompletion)
            }, receiveValue: { result in
                completion(result)
            })
    }
}

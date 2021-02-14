//
//  AccountWidgetEntryFactory.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import Combine
import Foundation
import WidgetKit

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

    func createTimeline(completion: @escaping (Timeline<AccountEntry>) -> Void) {
        entrySubscriber = repository.getAccouts()
            .retry(1)
            .map { dataModel -> Result<Account, Error> in
                if let firstAccount = dataModel.first {
                    return .success(firstAccount)
                } else {
                    return .failure(FactoryError.noAccount)
                }
            }
            .zip(repository.getCurrentMarketHourType().setFailureType(to: Error.self))
            .receive(on: RunLoop.main)
            .map { (firstAccountResponse, sessionType) -> Timeline<AccountEntry> in
                if let account = try? firstAccountResponse.get() {
                    if sessionType == .closed {
                        return Timeline(entries: [AccountEntry(account, sessionType: sessionType)], policy: .after(Date.tomorrow))
                    } else {
                        return Timeline(entries: [AccountEntry(account, sessionType: sessionType)], policy: .atEnd)
                    }
                } else {
                    return Timeline(entries: [AccountEntry.SnapshotVariation.complete], policy: .atEnd)
                }
            }
            .catch { (_) -> AnyPublisher<Timeline<AccountEntry>, Never> in
                Just(Timeline(entries: [AccountEntry.SnapshotVariation.complete], policy: .atEnd))
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { finishedCompletion in
                print(finishedCompletion)
            }, receiveValue: { result in
                completion(result)
            })
    }
}

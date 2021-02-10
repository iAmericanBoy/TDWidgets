//
//  AccountWidgetViewModel.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import Combine
import Foundation

class AccountWidgetViewModel {
    // MARK: Members:

    private let repository: Repository

    // MARK: Subscribers:

    private var accountsSubscriber: AnyCancellable?

    init(repository: Repository = RepositoryImpl()) {
        self.repository = repository
    }

    func getAccounts(completion: @escaping (Result<AccountEntry, Error>) -> Void) {
        accountsSubscriber = repository.getAccouts()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { finishedCompletion in
                switch finishedCompletion {
                case .finished:
                    print("finished")
                    () // We don't care that it finished currently since we should have received a value already
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { dataModel in
                if let firstAccount = dataModel.first {
                    completion(.success(AccountEntry(firstAccount, sessionType: .closed)))
                }
            })
    }
}

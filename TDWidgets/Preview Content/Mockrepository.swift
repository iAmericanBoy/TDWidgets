//
//  Mockrepository.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Combine
import Foundation

class MockRepositry: Repository {
    var accountDataModelValue: AccountDataModel!
    func getAccouts() -> AnyPublisher<AccountDataModel, Error> {
        let mockResult: Result<AccountDataModel, Error> = .success(accountDataModelValue)
        return mockResult.publisher.eraseToAnyPublisher()
    }
}

extension MockRepositry {
    struct PreviewVariation {
        static var complete: Repository {
            let mock = MockRepositry()
            mock.accountDataModelValue = []
            return mock
        }
    }
}

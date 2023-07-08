//
//  ActivityViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import Foundation


class ActivityViewModel {
    // MARK: - Public Properties
    public let pageTitle = "Recent activity"
    
    @Published public var userActivities: [ActivityCellViewModel] = []
    
    // MARK: - Private Properties
    private let mockAPIClient = AssetsAPIMockClient()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init() {
        getUserActivities()
    }
    
    // MARK: - Private Methods
    private func getUserActivities() {
        #warning("this is mock request and we should refactor this section")
        mockAPIClient.coinHistory().sink { completed in
            switch completed {
            case .finished:
                print("Coin history received successfully")
            case let .failure(error):
                print(error)
            }
        } receiveValue: { [weak self] activities in
            let walletManager = PinoWalletManager()
            self?.userActivities = activities.compactMap {
                return ActivityCellViewModel(activityModel: $0, currentAddress: walletManager.currentAccount.eip55Address)
            }
        }.store(in: &cancellables)
    }
}

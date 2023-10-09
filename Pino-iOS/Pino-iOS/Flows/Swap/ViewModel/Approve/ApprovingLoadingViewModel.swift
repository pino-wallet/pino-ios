//
//  ApprovingLoadingViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/4/23.
//

import Combine
import Foundation

class ApprovingLoadingViewModel {
	// MARK: - Private Properties

	private let approveTxHash: String
	private let activityAPIClient = ActivityAPIClient()
	private var requestTimer: Timer?
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var isApproved = false
    
    // MARK: - Initializers

    init(approveTxHash: String) {
        self.approveTxHash = approveTxHash

        setupTimer()
    }

	// MARK: - Public Methods

	public func getApproveTransactionFormVC() {
		setupTimer()
		requestTimer?.fire()
	}

	// MARK: - Private Methods

	private func setupTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 2,
			target: self,
			selector: #selector(getApproveTransaction),
			userInfo: nil,
			repeats: true
		)
	}

	private func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	@objc
	private func getApproveTransaction() {
		activityAPIClient.singleActivity(txHash: approveTxHash).sink { completed in
			switch completed {
			case .finished:
				print("Approve activity received successfully")
			case let .failure(error):
				switch error {
				case .notFound:
					print("Approve is in pending")
				default:
					print("Failed request")
				}
			}
		} receiveValue: { _ in
			self.destroyTimer()
			self.isApproved = true
		}.store(in: &cancellables)
	}

	
}

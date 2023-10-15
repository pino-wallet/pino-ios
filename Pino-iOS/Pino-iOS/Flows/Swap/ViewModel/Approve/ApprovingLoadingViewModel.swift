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
    
    public let takeFewSecondsText = "This may take a few seconds."
    public let takeFewMinutesText = "This may take a few minutes."
    public let warningImageName = "warning"
    public let speedUpImageName = "speed_up"
    public let speedUpButtonText = "Speed up"
    public let approvingText = "Approving..."
    public let tryAgainButtonText = "Try again"
    public let tryAgainDescriptionText = "Please try again"
    public let somethingWentWeongText = "Something went wrong!"
    public let speedUpDescriptionText = "Your transaction is taking longer than usual, likely due to network congestion. For faster confirmation, try the 'Speed up' option."
    public let grayErrorAlertImageName = "gray_error_alert"
    public let dismissButtonImageName = "close"

	@Published
    public var approveLoadingStatus: ApproveLoadingStatuses = .normalLoading
    
    public enum ApproveLoadingStatuses {
        case normalLoading
        case showSpeedUp
        case fastLoading
        case error
        case done
    }

	// MARK: - Initializers

	init(approveTxHash: String) {
		self.approveTxHash = approveTxHash
	}

	// MARK: - Public Methods

	public func getApproveTransactionFormVC() {
		setupTimer()
		requestTimer?.fire()
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
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
            self.approveLoadingStatus = .done
			self.destroyTimer()
		}.store(in: &cancellables)
	}
}

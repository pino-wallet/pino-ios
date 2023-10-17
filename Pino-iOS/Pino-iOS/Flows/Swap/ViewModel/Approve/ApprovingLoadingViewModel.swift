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

	private let activityAPIClient = ActivityAPIClient()
	private var requestTimer: Timer?
	private let showSpeedUpTimeOut: Double = 10
	private var approveGasInfo: GasInfo?
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
	public let speedUpDescriptionText =
		"Your transaction is taking longer than usual, likely due to network congestion. For faster confirmation, try the 'Speed up' option."
	public let grayErrorAlertImageName = "gray_error_alert"
	public let dismissButtonImageName = "close"

	public var approveTxHash: String
	@Published
	public var approveLoadingStatus: ApproveLoadingStatuses = .normalLoading
	public var formattedFeeInDollar: String {
		guard let approveGasInfo else {
			return "0"
		}
		return approveGasInfo.feeInDollar.priceFormat
	}

	public enum ApproveLoadingStatuses {
		case normalLoading
		case showSpeedUp
		case fastLoading
		case error
		case done
	}

	// MARK: - Initializers

	init(approveTxHash: String, approveGasInfo: GasInfo?) {
		self.approveTxHash = approveTxHash
		self.approveGasInfo = approveGasInfo

		showSpeedUpAfterSomeTime()
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

	public func changeTXHash(newTXHash: String) {
		approveTxHash = newTXHash
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

	private func showSpeedUpAfterSomeTime() {
		DispatchQueue.main.asyncAfter(deadline: .now() + showSpeedUpTimeOut) {
			self.approveLoadingStatus = .showSpeedUp
		}
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

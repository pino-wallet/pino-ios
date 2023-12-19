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
	private var approveContractVM: ApproveContractViewModel
	private let web3 = Web3Core.shared
	private let coreDataManager = CoreDataManager()
	private let activityHelper = ActivityHelper()
	private let walletManager = PinoWalletManager()
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

	public var approveTxHash: String?
	public var approveContractDetails: ContractDetailsModel
	@Published
	public var approveLoadingStatus: ApproveLoadingStatuses = .normalLoading
	public var formattedFeeInDollar: String {
		guard let approveGasInfo = approveContractVM.approveGasInfo else {
			return "0"
		}
		return approveGasInfo.feeInDollar!.priceFormat
	}

	public enum ApproveLoadingStatuses {
		case normalLoading
		case showSpeedUp
		case fastLoading
		case error
		case done
	}

	// MARK: - Initializers

	init(approveContractDetails: ContractDetailsModel, approveContractVM: ApproveContractViewModel) {
		self.approveContractDetails = approveContractDetails
		self.approveContractVM = approveContractVM

		approveToken()
	}

	// MARK: - Public Methods

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	public func changeTXHash(newTXHash: String) {
		approveTxHash = newTXHash
		approveLoadingStatus = .fastLoading
	}

	public func approveToken() {
		approveLoadingStatus = .normalLoading
		web3.approveContract(contractDetails: approveContractDetails).done { trxHash in
			print("APPROVE TRX HASH: \(trxHash)")
			self.approveTxHash = trxHash
			self.createApprovePendingActivity(trxHash: trxHash)
			self.startTimer()
			self.showSpeedUpAfterSomeTime()
		}.catch { error in
			print("Failed to give permission")
			self.approveLoadingStatus = .error
		}
	}

	// MARK: - Private Methods

	private func createApprovePendingActivity(trxHash: String) {
		coreDataManager.addNewApproveActivity(
			activityModel: ActivityApproveModel(
				txHash: trxHash,
				type: "approve",
				detail: ApproveActivityDetail(
					amount: "0",
					owner: "",
					spender: "",
					tokenID: approveContractVM.approveAssetVM.id
				),
				fromAddress: "",
				toAddress: "",
				blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
				gasUsed: (approveContractVM.approveGasInfo?.increasedGasLimit!.description)!,
				gasPrice: (approveContractVM.approveGasInfo?.baseFeeWithPriorityFee.description)!
			),
			accountAddress: walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	private func startTimer() {
		setupTimer()
		requestTimer?.fire()
	}

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
		guard let approveTxHash else {
			return
		}
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

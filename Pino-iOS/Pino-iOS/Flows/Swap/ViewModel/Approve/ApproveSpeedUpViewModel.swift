//
//  ApproveSpeedUpViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/16/23.
//
import Combine
import Web3
import Web3_Utility

class ApproveSpeedUpViewModel {
	// MARK: - TypeAliases

	typealias DidSpeedUpTransactionType = (_ error: speedUpTransactionErrors?) -> Void

	// MARK: - Private Properties

	private let networkErrorToastMessage = "No internet connection"
	private let ethToken = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
	private let coreDataManager = CoreDataManager()
	private var newBigNumberGasPrice: BigNumber!
	private var transactionObject: EthereumTransactionObject!
	private var approveLoadingVM: ApprovingLoadingViewModel
	private var cancellables = Set<AnyCancellable>()
	private var activityCurrentStatus: ActivityDetailProperties.ActivityStatus = .pending

	// MARK: - Closures

	public var didSpeedUpTransaction: DidSpeedUpTransactionType

	// MARK: - Public Properties

	public let title = "Speed up"
	public let description = "Increase the fee to process your tx faster."
	public let currentFeeTitle = "Current fee"
	public let speedUpFeeTitle = "Speed up fee"
	public let confirmTitle = "Confirm"
	public let waitTitle = "Please wait"
	public let insufficientBalanceTitle = "Insufficient balance"
	public let errorTitle = "Error"
	public let errorImageName = "info"
	public let errorTransactionExist = "Your transaction has already been confirmed"
	public let errorSomethingWentWrong = "Something went wrong, please try again"
	public let speedUpArrow = "speed_up_arrow"
	public let gotItTitle = "Got it"

	@Published
	public var speedUpFeeInDollars = ""

	public enum speedUpTransactionErrors: Error {
		case somethingWentWrong
		case transactionExistError
		case insufficientBalanceError
	}

	// MARK: - Initializers

	init(approveLoadingVM: ApprovingLoadingViewModel, didSpeedUpTransaction: @escaping DidSpeedUpTransactionType) {
		self.approveLoadingVM = approveLoadingVM
		self.didSpeedUpTransaction = didSpeedUpTransaction

		setupBindings()
	}

	// MARK: - Public Methods

	public func speedUpTransaction() {
		Web3Core.shared.speedUpTransaction(
			tx: transactionObject,
			newGasPrice: EthereumQuantity(
				quantity: Utilities
					.parseToBigUInt(newBigNumberGasPrice.bigIntFormat, units: .custom(0))!
			)
		).done { txHash in
			guard let approveTxHash = self.approveLoadingVM.approveTxHash else {
				return
			}
			self.coreDataManager.performSpeedUpChanges(
				txHash: approveTxHash,
				newTxHash: txHash,
				newGasPrice: self.newBigNumberGasPrice.bigIntFormat
			)
			self.approveLoadingVM.changeTXHash(newTXHash: txHash)
			PendingActivitiesManager.shared.startActivityPendingRequests()
			self.didSpeedUpTransaction(nil)
		}.catch { error in
			if self.activityCurrentStatus == .complete {
				self.didSpeedUpTransaction(.transactionExistError)
			} else {
				self.didSpeedUpTransaction(.somethingWentWrong)
			}
		}
	}

	#warning("maybe we raftor this section later")
	public func getSpeedUpDetails() {
		guard let approveTxHash = approveLoadingVM.approveTxHash else {
			return
		}
		Web3Core.shared.getTransactionByHash(txHash: approveTxHash)
			.done { txObject in
				self.transactionObject = txObject
				Web3Core.shared.getGasPrice().done { gasPrice in
					let increasedBigNumberGasPrice = self.calculateIncreasedGasPrice(gasPrice: gasPrice)
					self.newBigNumberGasPrice = increasedBigNumberGasPrice
					let speedUpFee = self.calculateSpeedUpFee(
						increasedBigNumberGasPrice: increasedBigNumberGasPrice,
						gasUsed: txObject!.gas
					)
					self.speedUpFeeInDollars = self.calculateSpeedUpFeeInDollars(speedUpFee: speedUpFee)
						.priceFormat(of: .coin, withRule: .standard)

					if self.ethToken!.holdAmount.isZero || self.ethToken!.holdAmount < speedUpFee {
						self.didSpeedUpTransaction(.insufficientBalanceError)
					}
				}.catch { error in
					Toast.default(title: self.networkErrorToastMessage, style: .error)
						.show(haptic: .warning)
				}
			}.catch { error in
				Toast.default(title: self.networkErrorToastMessage, style: .error)
					.show(haptic: .warning)
			}
	}

	// MARK: - Private Methods

	#warning("maybe we raftor this section later")
	private func calculateIncreasedGasPrice(gasPrice: EthereumQuantity) -> BigNumber {
		let bigNumberOneHoundered = 100.bigNumber
		let bigNumberTen = 10.bigNumber
		let bigNumberGasPrice = BigNumber(number: "\(gasPrice.quantity)", decimal: 0)
		let bigNumberOnePercentOfGasPrice = BigNumber(
			number: (bigNumberGasPrice / bigNumberOneHoundered)!,
			decimal: 0
		)
		let increasedBigNumberGasPrice = BigNumber(
			number: bigNumberGasPrice + (bigNumberOnePercentOfGasPrice * bigNumberTen),
			decimal: 0
		)

		return increasedBigNumberGasPrice
	}

	private func calculateSpeedUpFee(increasedBigNumberGasPrice: BigNumber, gasUsed: EthereumQuantity) -> BigNumber {
		let bigNumberTranscationGasUsed = BigNumber(number: "\(gasUsed.quantity)", decimal: 0)
		let speedUpFee = BigNumber(number: increasedBigNumberGasPrice * bigNumberTranscationGasUsed, decimal: 18)

		return speedUpFee
	}

	private func calculateSpeedUpFeeInDollars(speedUpFee: BigNumber) -> BigNumber {
		let ethPrice = ethToken?.price
		let feeInDollars = speedUpFee * ethPrice!
		return feeInDollars
	}

	private func setupBindings() {
		approveLoadingVM.$approveLoadingStatus.sink { approveLoadingStatus in
			if approveLoadingStatus == .done {
				self.activityCurrentStatus = .complete
			}
		}.store(in: &cancellables)
	}
}

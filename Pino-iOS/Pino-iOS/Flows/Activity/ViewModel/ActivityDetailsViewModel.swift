//
//  ActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import Combine
import Foundation

class ActivityDetailsViewModel {
	// MARK: - Private Properties

	private let globalAssetsList = GlobalVariables.shared.manageAssetsList
	private let activityAPIClient = ActivityAPIClient()
	private let errorFetchingToastMessage = "Error fetching activity from server"
	private let tryAgainToastMessage = "Please try again!"
	private var ethToken: AssetViewModel!
	private var feeInETH: BigNumber!
	private var swapDetailsVM: SwapDetailsViewModel?
	private var transfareDetailsVM: TransfareDetailsViewModel?
	private var requestTimer: Timer!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var activityDetails: ActivityCellViewModel
	#warning("this is for test")
	public let unVerifiedAssetIconName = "unverified_asset"
	public let dismissNavigationIconName = "dissmiss"
	public let swapDownArrow = "swap_down_arrow"
	public let dateTitle = "Date"
	public let statusTitle = "Status"
	public let protocolTitle = "Protocol"
	public let providerTitle = "Provider"
	public let fromTitle = "From"
	public let toTitle = "To"
	public let typeTitle = "Type"
	public let feeTitle = "Fee"
	public let viewEthScanTitle = "View on etherscan"
	public let viewEthScanIconName = "primary_right_arrow"
	public let unknownTransactionMessage =
		"We do not show more details about unknown transactions. If you want, go to the Etherscan."
	public let unknownTransactionIconName = "gray_error_alert"
	#warning("tooltips are for test")
	public let feeActionSheetText = "this is fee"
	public let statusActionSheetText = "this is status"
	public let typeActionSheetText = "this is type"
	public let copyFromAddressText = "From address has been copied"
	public let copyToAddressText = "To address has been copied"

	// header properties
	#warning("this section is mock and for test")
	public var assetIcon: URL? {
		transfareDetailsVM?.transfareTokenImage
	}

	public var assetAmountTitle: String? {
		"\(transfareDetailsVM?.transfareTokenAmount.sevenDigitFormat ?? "") \(transfareDetailsVM?.transfareTokenSymbol ?? "")"
	}

	public var fromTokenSymbol: String? {
		swapDetailsVM?.fromTokenSymbol
	}

	public var toTokenSymbol: String? {
		swapDetailsVM?.toTokenSymbol
	}

	public var fromTokenIcon: URL? {
		swapDetailsVM?.fromTokenImage
	}

	public var toTokenIcon: URL? {
		swapDetailsVM?.toTokenImage
	}

	public var fromTokenAmount: String? {
		swapDetailsVM?.fromTokenAmount.sevenDigitFormat
	}

	public var toTokenAmount: String? {
		swapDetailsVM?.toTokenAmount.sevenDigitFormat
	}

	// information properties
	public var formattedDate: String {
		activityDetails.formattedTime
	}

	public var fullFormattedDate: String {
		let activityHelper = ActivityHelper()
		let activityDate = activityHelper
			.getActivityDate(activityBlockTime: activityDetails.defaultActivityModel.blockTime)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM-d-yyyy HH:mm:ss Z"
		return dateFormatter.string(from: activityDate)
	}

	public var protocolName: String? {
		activityDetails.defaultActivityModel.detail?.activityProtocol?.capitalized
	}

	public var protocolImage: String? {
		"1inch"
	}

	public var formattedFeeInDollar: String {
		let feeInDollar = ethToken.price * feeInETH
		return feeInDollar.priceFormat
	}

	public var formattedFeeInETH: String {
		feeInETH.sevenDigitFormat.ethFormatting
	}

	public var status: ActivityStatus {
		switch activityDetails.status {
		case .failed:
			return ActivityStatus.failed
		case .success:
			return ActivityStatus.complete
		case .pending:
			return ActivityStatus.pending
		}
	}

	public var typeName: String {
		activityDetails.uiType.rawValue
	}

	public var fromAddress: String?

	public var toAddress: String?

	public var fromIcon: String?

	public var toIcon: String?

	public var fromName: String?

	public var toName: String?

	public var fullFromAddress: String? {
		activityDetails.defaultActivityModel.fromAddress
	}

	public var fullToAddress: String? {
		activityDetails.defaultActivityModel.toAddress
	}

	public var uiType: ActivityUIType {
		activityDetails.uiType
	}

	public var pageTitle: String {
		activityDetails.uiType.pageTitleText
	}

	// MARK: - Initializers

	init(activityDetails: ActivityCellViewModel) {
		self.activityDetails = activityDetails

		setDetailsVM()
		setTransfareDetails()
		setEthToken()
		setFeeInETH()
	}

	// MARK: - Public Methods

	public func getActivityDetailsFromVC() {
		if activityDetails.status == .pending {
			setupRequestTimer()
			requestTimer.fire()
		}
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	public func refreshData() {
		if activityDetails.status == .pending {
			requestTimer?.fire()
		} else {
			activityDetails = activityDetails
		}
	}

	// MARK: - Private Methods

	private func setDetailsVM() {
		switch activityDetails.uiType {
		case .swap:
			swapDetailsVM = SwapDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel,
				globalAssetsList: globalAssetsList!
			)

		case .borrow:
			return
		case .send:
			transfareDetailsVM = TransfareDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel,
				globalAssetsList: globalAssetsList!
			)

		case .receive:
			transfareDetailsVM = TransfareDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel,
				globalAssetsList: globalAssetsList!
			)

		case .unknown:
			return
		case .collateral:
			return
		case .un_collateral:
			return
		case .invest:
			return
		case .repay:
			return
		case .withdraw:
			return
		}
	}

	private func setTransfareDetails() {
		switch activityDetails.uiType {
		case .send:
			let currentAccount = PinoWalletManager().currentAccount
			fromName = currentAccount.name
			fromIcon = currentAccount.avatarIcon
			toAddress = transfareDetailsVM?.transfareToAddress
		case .receive:
			let currentAccount = PinoWalletManager().currentAccount
			toName = currentAccount.name
			toIcon = currentAccount.avatarIcon
			fromAddress = transfareDetailsVM?.transfareFromAddress
		default:
			return
		}
	}

	private func setEthToken() {
		ethToken = globalAssetsList?.first(where: { $0.isEth })
	}

	private func setFeeInETH() {
		let bigNumberGasPrice = BigNumber(number: activityDetails.defaultActivityModel.gasPrice, decimal: 0)
		let bigNumberGasUsed = BigNumber(number: activityDetails.defaultActivityModel.gasUsed, decimal: 0)

		feeInETH = BigNumber(number: bigNumberGasUsed * bigNumberGasPrice, decimal: ethToken?.decimal ?? 0)
	}

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 12,
			target: self,
			selector: #selector(getActivityDetails),
			userInfo: nil,
			repeats: true
		)
	}

	@objc
	private func getActivityDetails() {
		activityAPIClient.singleActivity(txHash: activityDetails.defaultActivityModel.txHash).sink { completed in
			switch completed {
			case .finished:
				print("Activity received successfully")
			case let .failure(error):
				print(error)
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: self.tryAgainToastMessage,
					style: .error
				)
				.show(haptic: .warning)
			}
		} receiveValue: { activityDetails in
			self.setDetailsVM()
			self.setTransfareDetails()
			self.activityDetails = ActivityCellViewModel(activityModel: activityDetails)
		}.store(in: &cancellables)
	}
}

extension ActivityDetailsViewModel {
	enum ActivityStatus {
		case complete
		case failed
		case pending

		public var description: String {
			switch self {
			case .complete:
				return "Complete"
			case .failed:
				return "Failed"
			case .pending:
				return "Pending"
			}
		}
	}
}

extension ActivityUIType {
	fileprivate var pageTitleText: String {
		switch self {
		case .swap:
			return "Swap details"
		case .borrow:
			return "Borrow details"
		case .send:
			return "Send details"
		case .receive:
			return "Receive details"
		case .unknown:
			return "Unknown transaction"
		case .collateral:
			return "Collateral details"
		case .un_collateral:
			return "Uncollateral details"
		case .invest:
			return "Investment details"
		case .repay:
			return "Repay details"
		case .withdraw:
			return "Withdraw details"
		}
	}
}

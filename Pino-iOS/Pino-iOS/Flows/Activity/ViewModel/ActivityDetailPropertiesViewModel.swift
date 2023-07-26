//
//  ActivityDetailPropertiesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/25/23.
//

import Foundation

struct ActivityDetailProperties {
	// MARK: - Private Properties

	private var activityDetails: ActivityCellViewModel!
	private var globalAssetsList: [AssetViewModel] {
		GlobalVariables.shared.manageAssetsList!
	}

	private var ethToken: AssetViewModel!
	private var feeInETH: BigNumber!
	private var swapDetailsVM: SwapDetailsViewModel?
	private var transferDetailsVM: TransferDetailsViewModel?

	// MARK: - Public Properties

	// header properties
	#warning("this section is mock and for test")
	public var assetIcon: URL? {
		transferDetailsVM?.transferTokenImage
	}

	public var assetAmountTitle: String? {
		"\(transferDetailsVM?.transferTokenAmount.sevenDigitFormat ?? "") \(transferDetailsVM?.transferTokenSymbol ?? "")"
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
        let activityHelper = ActivityHelper()
        let activityDate = activityHelper.getActivityDate(activityBlockTime: activityDetails.defaultActivityModel.blockTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy, HH:mm"
        return dateFormatter.string(from: activityDate)
	}

	public var protocolName: String? {
		activityDetails.defaultActivityModel.detail?.activityProtocol?.capitalized
	}

	#warning("this image is for test")
	public var protocolImage: String? {
		"uniswap_protocol"
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
		setTransferDetails()
		setEthToken()
		setFeeInETH()
	}

	// MARK: -  Private Methods

	private mutating func setDetailsVM() {
		switch activityDetails.uiType {
		case .swap:
			swapDetailsVM = SwapDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel,
				globalAssetsList: globalAssetsList
			)

		case .borrow:
			return
		case .send:
			transferDetailsVM = TransferDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel,
				globalAssetsList: globalAssetsList
			)

		case .receive:
			transferDetailsVM = TransferDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel,
				globalAssetsList: globalAssetsList
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

	private mutating func setTransferDetails() {
		switch activityDetails.uiType {
		case .send:
			let currentAccount = PinoWalletManager().currentAccount
			fromName = currentAccount.name
			fromIcon = currentAccount.avatarIcon
			toAddress = transferDetailsVM?.transferToAddress
		case .receive:
			let currentAccount = PinoWalletManager().currentAccount
			toName = currentAccount.name
			toIcon = currentAccount.avatarIcon
			fromAddress = transferDetailsVM?.transferFromAddress
		default:
			return
		}
	}

	private mutating func setEthToken() {
		ethToken = globalAssetsList.first(where: { $0.isEth })
	}

	private mutating func setFeeInETH() {
		let bigNumberGasPrice = BigNumber(number: activityDetails.defaultActivityModel.gasPrice, decimal: 0)
		let bigNumberGasUsed = BigNumber(number: activityDetails.defaultActivityModel.gasUsed, decimal: 0)

		feeInETH = BigNumber(number: bigNumberGasUsed * bigNumberGasPrice, decimal: ethToken?.decimal ?? 0)
	}
}

extension ActivityDetailProperties {
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
			return "Swap"
		case .borrow:
			return "Borrow"
		case .send:
			return "Send"
		case .receive:
			return "Receive"
		case .unknown:
			return "Unknown"
		case .collateral:
			return "Add collateral"
		case .un_collateral:
			return "Withdraw collateral"
		case .invest:
			return "Invest"
		case .repay:
			return "Repay"
		case .withdraw:
			return "Withdraw investment"
		}
	}
}

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
	private var swapDetailsVM: SwapActivityDetailsViewModel?
	private var transferDetailsVM: TransferActivityDetailsViewModel?
	private var borrowDetailsVM: BorrowActivityDetailsViewModel?
	private var repayDetailsVM: RepayActivityDetailsViewModel?
	private var withdrawInvestmentDetailsVM: WithdrawInvestmentActivityDetailsViewModel?
	private var investDetailsVM: InvestActivityDetailsViewModel?
    private var withdrawCollateralDetailsVM: WithdrawCollateralActivityDetailsViewModel?
    private var collateralDetailsVM: CollateralActivityDetailsViewModel?

	// MARK: - Public Properties

	// header properties
	public var assetIcon: URL? {
		switch activityDetails.uiType {
		case .swap:
			return nil
		case .borrow:
			return borrowDetailsVM?.tokenImage
		case .send:
			return transferDetailsVM?.transferTokenImage
		case .receive:
			return transferDetailsVM?.transferTokenImage
		case .repay:
			return repayDetailsVM?.tokenImage
		case .withdraw_investment:
			return withdrawInvestmentDetailsVM?.tokenImage
		case .invest:
			return investDetailsVM?.tokenImage
        case .collateral:
            return collateralDetailsVM?.tokenImage
        case .withdraw_collateral:
            return withdrawCollateralDetailsVM?.tokenImage
        }
	}

	public var assetAmountTitle: String? {
		switch activityDetails.uiType {
		case .swap:
			return nil
		case .borrow:
			return "\(borrowDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(borrowDetailsVM?.tokenSymbol ?? "")"
		case .send:
			return "\(transferDetailsVM?.transferTokenAmount.sevenDigitFormat ?? "") \(transferDetailsVM?.transferTokenSymbol ?? "")"
		case .receive:
			return "\(transferDetailsVM?.transferTokenAmount.sevenDigitFormat ?? "") \(transferDetailsVM?.transferTokenSymbol ?? "")"
		case .repay:
			return "\(repayDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(repayDetailsVM?.tokenSymbol ?? "")"
		case .withdraw_investment:
			return "\(withdrawInvestmentDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(withdrawInvestmentDetailsVM?.tokenSymbol ?? "")"
		case .invest:
			return "\(investDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(investDetailsVM?.tokenSymbol ?? "")"
        case .collateral:
            return "\(collateralDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(collateralDetailsVM?.tokenSymbol ?? "")"
        case .withdraw_collateral:
            return "\(withdrawCollateralDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(withdrawCollateralDetailsVM?.tokenSymbol ?? "")"
        }
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
		let activityDate = activityHelper
			.getActivityDate(activityBlockTime: activityDetails.defaultActivityModel.blockTime)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d yyyy, HH:mm"
		return dateFormatter.string(from: activityDate)
	}

	public var protocolName: String? {
		switch activityDetails.uiType {
		case .swap:
			return swapDetailsVM?.activityProtocol.capitalized
		case .borrow:
			return borrowDetailsVM?.activityProtocol.capitalized
		case .repay:
			return repayDetailsVM?.activityProtocol.capitalized
		case .withdraw_investment:
			return withdrawInvestmentDetailsVM?.activityProtocol.capitalized
		case .invest:
			return investDetailsVM?.activityProtocol.capitalized
		case .send:
			return nil
		case .receive:
			return nil
        case .collateral:
            return collateralDetailsVM?.activityProtocol.capitalized
        case .withdraw_collateral:
            return withdrawCollateralDetailsVM?.activityProtocol.capitalized
        }
	}

	public var protocolImage: String? {
		switch activityDetails.uiType {
		case .swap:
			return swapDetailsVM?.activityProtocol
		case .borrow:
			return borrowDetailsVM?.activityProtocol
		case .repay:
			return repayDetailsVM?.activityProtocol
		case .withdraw_investment:
			return withdrawInvestmentDetailsVM?.activityProtocol
		case .invest:
			return investDetailsVM?.activityProtocol
		case .send:
			return nil
		case .receive:
			return nil
        case .collateral:
            return collateralDetailsVM?.activityProtocol
        case .withdraw_collateral:
            return withdrawCollateralDetailsVM?.activityProtocol
        }
	}

	public var formattedFeeInDollar: String {
		let feeInDollar = ethToken.price * feeInETH
		if feeInDollar.isZero {
			return "-"
		} else {
			return feeInDollar.priceFormat
		}
	}

	public var formattedFeeInETH: String {
		if feeInETH.isZero {
			return "-"
		} else {
			return feeInETH.sevenDigitFormat.ethFormatting
		}
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

	public var fromAddress: String? {
		transferDetailsVM?.transferFromAddress
	}

	public var toAddress: String? {
		transferDetailsVM?.transferToAddress
	}

	public var userFromAccountInfo: TransferActivityDetailsViewModel.UserAccountInfoType? {
		transferDetailsVM?.userFromAccountInfo
	}

	public var userToAccountInfo: TransferActivityDetailsViewModel.UserAccountInfoType? {
		transferDetailsVM?.userToAccountInfo
	}

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

	public var exploreURL: URL {
		URL(string: activityDetails.defaultActivityModel.txHash.ethScanTxURL)!
	}

	// MARK: - Initializers

	init(activityDetails: ActivityCellViewModel) {
		self.activityDetails = activityDetails

		setDetailsVM()
		setEthToken()
		setFeeInETH()
	}

	// MARK: -  Private Methods

	private mutating func setDetailsVM() {
		switch activityDetails.uiType {
		case .swap:
			swapDetailsVM = SwapActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivitySwapModel,
				globalAssetsList: globalAssetsList
			)

		case .borrow:
			borrowDetailsVM = BorrowActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivityBorrowModel,
				globalAssetsList: globalAssetsList
			)
		case .send:
			transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivityTransferModel,
				globalAssetsList: globalAssetsList
			)

		case .receive:
			transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivityTransferModel,
				globalAssetsList: globalAssetsList
			)
		case .repay:
			repayDetailsVM = RepayActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivityRepayModel,
				globalAssetsList: globalAssetsList
			)
		case .withdraw_investment:
			withdrawInvestmentDetailsVM = WithdrawInvestmentActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivityWithdrawModel,
				globalAssetsList: globalAssetsList
			)
		case .invest:
			investDetailsVM = InvestActivityDetailsViewModel(
				activityModel: activityDetails.defaultActivityModel as! ActivityInvestModel,
				globalAssetsList: globalAssetsList
			)
        case .collateral:
            collateralDetailsVM = CollateralActivityDetailsViewModel(activityModel: activityDetails.defaultActivityModel as! ActivityCollateralModel, globalAssetsList: globalAssetsList)
        case .withdraw_collateral:
            withdrawCollateralDetailsVM = WithdrawCollateralActivityDetailsViewModel(activityModel: activityDetails.defaultActivityModel as! ActivityCollateralModel, globalAssetsList: globalAssetsList)
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
		case .repay:
			return "Repay"
		case .withdraw_investment:
			return "Withdraw investment"
		case .invest:
			return "Invest"
        case .collateral:
            return "Collateral"
        case .withdraw_collateral:
            return "Withdraw collateral"
        }
	}
}

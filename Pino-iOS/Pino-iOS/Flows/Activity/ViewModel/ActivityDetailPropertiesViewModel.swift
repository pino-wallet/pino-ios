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

	private var activityHelper = ActivityHelper()
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
	private var collateralStatusDetailsVM: CollateralStatusActivityDetailsViewModel?
	private var approveDetailsVM: ApproveActivityDetailsViewModel?

	// MARK: - Public Properties

	// header properties
	public var assetIcon: URL? {
		switch activityDetails.uiType {
		case .swap:
			return nil
		case .borrow:
			return borrowDetailsVM?.tokenImage
		case .send:
			return transferDetailsVM?.tokenImage
		case .receive:
			return transferDetailsVM?.tokenImage
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
		case .enable_collateral:
			return collateralStatusDetailsVM?.tokenImage
		case .disable_collateral:
			return collateralStatusDetailsVM?.tokenImage
		case .approve:
			return approveDetailsVM?.tokenImage
		}
	}

	public var assetAmountTitle: String? {
		switch activityDetails.uiType {
		case .swap:
			return nil
		case .borrow:
			return "\(borrowDetailsVM?.tokenAmount.sevenDigitFormat ?? "") \(borrowDetailsVM?.tokenSymbol ?? "")"
		case .send:
			return "\(transferDetailsVM?.transferTokenAmount.sevenDigitFormat ?? "") \(transferDetailsVM?.tokenSymbol ?? "")"
		case .receive:
			return "\(transferDetailsVM?.transferTokenAmount.sevenDigitFormat ?? "") \(transferDetailsVM?.tokenSymbol ?? "")"
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
		case .enable_collateral:
			return "Enable as collateral"
		case .disable_collateral:
			return "Disable as collateral"
		case .approve:
			return "Approve to Permit 2"
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
        dateFormatter.locale = Locale(identifier: GlobalVariables.shared.timeZoneIdentifier)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: GlobalVariables.shared.timeZoneSecondsFromGMT)
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
		case .enable_collateral:
			return collateralStatusDetailsVM?.activityProtocol.capitalized
		case .disable_collateral:
			return collateralStatusDetailsVM?.activityProtocol.capitalized
		case .approve:
			return nil
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
		case .enable_collateral:
			return collateralStatusDetailsVM?.activityProtocol
		case .disable_collateral:
			return collateralStatusDetailsVM?.activityProtocol
		case .approve:
			return nil
		}
	}

	public var formattedFeeInDollar: String {
		let feeInDollar = ethToken.price * feeInETH
		if feeInDollar.isZero {
			return GlobalZeroAmounts.dollars.zeroAmount
		} else {
			return feeInDollar.priceFormat
		}
	}

	public var formattedFeeInETH: String {
		if feeInETH.isZero {
			return GlobalZeroAmounts.tokenAmount.zeroAmount
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
		activityHelper.globalAssetsList = globalAssetsList
		switch activityDetails.uiType {
		case .swap:
			guard let swapActivityModel = activityDetails.defaultActivityModel as? ActivitySwapModel,
			      let fromToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: swapActivityModel.detail.fromToken.tokenID),
			      let toToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: swapActivityModel.detail.toToken.tokenID) else {
				fatalError("Cant find swap tokens in global assets list")
			}
			swapDetailsVM = SwapActivityDetailsViewModel(
				activityModel: swapActivityModel,
				fromToken: fromToken,
				toToken: toToken
			)
		case .borrow:
			guard let borrowActivityModel = activityDetails.defaultActivityModel as? ActivityBorrowModel,
			      let borrowToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: borrowActivityModel.detail.token.tokenID) else {
				fatalError("Cant find borrow token in global assets list")
			}
			borrowDetailsVM = BorrowActivityDetailsViewModel(
				activityModel: borrowActivityModel,
				token: borrowToken
			)
		case .send:
			guard let transferActivityModel = activityDetails.defaultActivityModel as? ActivityTransferModel,
			      let transferToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: transferActivityModel.detail.tokenID) else {
				fatalError("Cant find transfer token in global assets list")
			}
			transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: transferActivityModel,
				token: transferToken
			)
		case .receive:
			guard let transferActivityModel = activityDetails.defaultActivityModel as? ActivityTransferModel,
			      let transferToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: transferActivityModel.detail.tokenID) else {
				fatalError("Cant find transfer token in global assets list")
			}
			transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: transferActivityModel,
				token: transferToken
			)
		case .repay:
			guard let repayActivityModel = activityDetails.defaultActivityModel as? ActivityRepayModel,
			      let repayToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: repayActivityModel.detail.repaidToken.tokenID) else {
				fatalError("Cant find repay token in global assets list")
			}
			repayDetailsVM = RepayActivityDetailsViewModel(
				activityModel: repayActivityModel,
				token: repayToken
			)
		case .withdraw_investment:
			guard let withdrawActivityModel = activityDetails.defaultActivityModel as? ActivityWithdrawModel,
			      let withdrawToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: withdrawActivityModel.detail.tokens[0].tokenID) else {
				fatalError("Cant find withdraw token in global assets list")
			}
			withdrawInvestmentDetailsVM = WithdrawInvestmentActivityDetailsViewModel(
				activityModel: withdrawActivityModel,
				token: withdrawToken
			)
		case .invest:
			guard let investActivityModel = activityDetails.defaultActivityModel as? ActivityInvestModel,
			      let investToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: investActivityModel.detail.tokens[0].tokenID) else {
				fatalError("Cant find invest token in global assets list")
			}
			investDetailsVM = InvestActivityDetailsViewModel(
				activityModel: investActivityModel,
				token: investToken
			)
		case .collateral:
			guard let collateralActivityModel = activityDetails.defaultActivityModel as? ActivityCollateralModel,
			      let collateralToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: collateralActivityModel.detail.tokens[0].tokenID) else {
				fatalError("Cant find collateral token in global assets list")
			}
			collateralDetailsVM = CollateralActivityDetailsViewModel(
				activityModel: collateralActivityModel,
				token: collateralToken
			)
		case .withdraw_collateral:
			guard let withdrawCollateralActivityModel = activityDetails.defaultActivityModel as? ActivityCollateralModel,
			      let withdrawCollateralToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: withdrawCollateralActivityModel.detail.tokens[0].tokenID) else {
				fatalError("Cant find withdraw collateral token in global assets list")
			}
			withdrawCollateralDetailsVM = WithdrawCollateralActivityDetailsViewModel(
				activityModel: withdrawCollateralActivityModel,
				token: withdrawCollateralToken
			)
		case .enable_collateral:
			guard let enableCollateralActivityModel = activityDetails.defaultActivityModel as? ActivityCollateralModel,
			      let enableCollateralToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: enableCollateralActivityModel.detail.tokens[0].tokenID) else {
				fatalError("Cant find enable collateral token in global assets list")
			}
			collateralStatusDetailsVM = CollateralStatusActivityDetailsViewModel(
				activityModel: enableCollateralActivityModel,
				token: enableCollateralToken
			)
		case .disable_collateral:
			guard let disableCollateralActivityModel = activityDetails.defaultActivityModel as? ActivityCollateralModel,
			      let disableCollateralToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: disableCollateralActivityModel.detail.tokens[0].tokenID) else {
				fatalError("Cant find disable collateral token in global assets list")
			}
			collateralStatusDetailsVM = CollateralStatusActivityDetailsViewModel(
				activityModel: disableCollateralActivityModel,
				token: disableCollateralToken
			)
		case .approve:
			guard let approveActivityModel = activityDetails.defaultActivityModel as? ActivityApproveModel,
			      var approveToken = activityHelper
			      .findTokenInGlobalAssetsList(tokenId: approveActivityModel.detail.tokenID) else {
				fatalError("Cant find approve token in global assets list")
			}
			if approveToken.isEth {
				guard let wethToken = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }) else {
					fatalError("Cant find WETH token in global assets list")
				}
				approveToken = wethToken
			}
			approveDetailsVM = ApproveActivityDetailsViewModel(
				activityModel: approveActivityModel,
				token: approveToken
			)
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
			return "Withdraw"
		case .invest:
			return "Invest"
		case .collateral:
			return "Collateralization"
		case .withdraw_collateral:
			return "Uncollateralization"
		case .enable_collateral:
			return "Enable collateralization"
		case .disable_collateral:
			return "Disable collateralization"
		case .approve:
			return "Approval"
		}
	}
}

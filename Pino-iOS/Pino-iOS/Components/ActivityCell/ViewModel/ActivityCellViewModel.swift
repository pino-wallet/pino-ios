//
//  CoinHistoryViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Foundation

struct ActivityCellViewModel: ActivityCellViewModelProtocol {
	// MARK: - Private Properties

	private let swapIcon = "swap"
	private let sendIcon = "send"
	private let receiveIcon = "receive"
	private let collateralIcon = "collateral"
	private let decreaseCollateral = "uncollateral"
	private let repaidIcon = "repaid"
	private let investIcon = "invest"
	private let withdrawIcon = "withdraw"
	private let borrowIcon = "borrow_transaction"

	private let currentAddress = PinoWalletManager().currentAccount.eip55Address

	private var activityModel: ActivityModelProtocol
	private var swapDetailsVM: SwapActivityDetailsViewModel?
	private var transferDetailsVM: TransferActivityDetailsViewModel?
	private var borrowDetailsVM: BorrowActivityDetailsViewModel?

	// MARK: - Internal Properties

	internal var globalAssetsList: [AssetViewModel] = [] {
		didSet {
			setupDetailsWithType()
			setValues()
		}
	}

	internal var activityType: ActivityType {
		ActivityType(rawValue: activityModel.type)!
	}

	internal var uiType: ActivityUIType {
		switch activityType {
		case .transfer:
			if isSendTransaction() {
				return .send
			}
			return .receive
		case .transfer_from:
			if isSendTransaction() {
				return .send
			}
			return .receive
		case .swap:
			return .swap
		//        case .create_investment, .increase_investment:
		//            return .invest
		//        case .create_withdraw_investment:
		//            if isWithdrawTransaction() {
		//                return .withdraw
		//            }
		//            return .invest
		//        case .decrease_investment:
		//            return .decrease_invest
		case .borrow:
			return .borrow
			//        case .repay, .repay_behalf:
			//            return .repay
			//        case .increase_collateral, .create_collateral:
			//            return .collateral
			//        case .decrease_collateral:
			//            return .decrease_collateral
			//        case .remove_collateral, .withdraw_investment:
			//            return .withdraw
		}
	}

	// MARK: - Public Properties

	var activityMoreInfo: String!

	public var blockTime: String {
		activityModel.blockTime
	}

	public var status: ActivityCellStatus {
		#warning("this section is mock and we should refactor this section")
		guard activityModel.failed != nil else {
			return .pending
		}
		if activityModel.failed! {
			return .failed
		} else {
			return .success
		}
	}

	public var icon: String!

	public var title: String!

	public var defaultActivityModel: ActivityModelProtocol {
		activityModel
	}

	// MARK: - Initializers

	init(activityModel: ActivityModelProtocol) {
		self.activityModel = activityModel
	}

	// MARK: - Private Methods

	private func isSendTransaction() -> Bool {
		if let transferActivity = activityModel as? ActivityTransferModel {
			if currentAddress.lowercased() == transferActivity.detail.from.lowercased() {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}

	private func isWithdrawTransaction() -> Bool {
		if let investActivity = activityModel as? ActivityInvestModel {
			if currentAddress.lowercased() == investActivity.fromAddress.lowercased() {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}

	private mutating func setupDetailsWithType() {
		switch activityType {
		case .transfer:
			transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: activityModel as! ActivityTransferModel,
				globalAssetsList: globalAssetsList
			)
		case .transfer_from:
			transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: activityModel as! ActivityTransferModel,
				globalAssetsList: globalAssetsList
			)
		case .swap:
			swapDetailsVM = SwapActivityDetailsViewModel(
				activityModel: activityModel as! ActivitySwapModel,
				globalAssetsList: globalAssetsList
			)
		case .borrow:
			borrowDetailsVM = BorrowActivityDetailsViewModel(
				activityModel: activityModel as! ActivityBorrowModel,
				globalAssetsList: globalAssetsList
			)
		}
	}

	private mutating func setValues() {
		#warning("this is mock and we should refactor this section")
		switch uiType {
		case .swap:
			// set cell title
			title = "Swap \(swapDetailsVM!.fromTokenSymbol) → \(swapDetailsVM!.toTokenSymbol)"
			// set cell moreInfo
			activityMoreInfo = swapDetailsVM!.activityProtocol.capitalized
			// set cell icon
			icon = swapIcon
		//        case .borrow:
		//            return "Borrow"
		case .send:
			// set cell title
			title =
				"Send \(transferDetailsVM!.transferTokenAmount.sevenDigitFormat) \(transferDetailsVM!.transferTokenSymbol)"
			// set cell moreInfo
			activityMoreInfo =
				"To: \(transferDetailsVM!.userToAccountInfo?.name ?? activityModel.toAddress.addressFromStartFormatting())"
			// set cell icon
			icon = sendIcon
		case .receive:
			// set cell title
			title =
				"Receive \(transferDetailsVM!.transferTokenAmount.sevenDigitFormat) \(transferDetailsVM!.transferTokenSymbol)"
			// set cell moreInfo
			activityMoreInfo =
				"From: \(transferDetailsVM!.userFromAccountInfo?.name ?? activityModel.fromAddress.addressFromStartFormatting())"
			// set cell icon
			icon = receiveIcon
		case .borrow:
			// set cell title
			title =
				"Borrow \(borrowDetailsVM!.tokenAmount.sevenDigitFormat) \(borrowDetailsVM!.tokenSymbol)"
			// set cell moreInfo
			activityMoreInfo = borrowDetailsVM!.activityProtocol.capitalized
			// set cell icon
			icon = borrowIcon
		}
	}
}

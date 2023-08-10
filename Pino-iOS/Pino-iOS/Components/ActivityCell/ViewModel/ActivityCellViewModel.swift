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
	private let UnCollateralIcon = "uncollateral"
	private let repaidIcon = "repaid"
	private let investIcon = "invest"
	private let withdrawIcon = "withdraw"
	private let borrowIcon = "borrow_transaction"

	private var activityModel: ActivityModelProtocol
	private var swapDetailsVM: SwapDetailsViewModel?
	private var transferDetailsVM: TransferDetailsViewModel?

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
		let currentAddress = PinoWalletManager().currentAccount.eip55Address
		if let transferActivity = activityModel as? ActivityTransferModel {
			if currentAddress.lowercased() == transferActivity.detail?.from?.lowercased() {
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
			transferDetailsVM = TransferDetailsViewModel(
				activityModel: activityModel as! ActivityTransferModel,
				globalAssetsList: globalAssetsList
			)
		case .transfer_from:
			transferDetailsVM = TransferDetailsViewModel(
				activityModel: activityModel as! ActivityTransferModel,
				globalAssetsList: globalAssetsList
			)
		case .swap:
			swapDetailsVM = SwapDetailsViewModel(
				activityModel: activityModel as! ActivitySwapModel,
				globalAssetsList: globalAssetsList
			)
		}
	}

	private mutating func setValues() {
		#warning("this is mock and we should refactor this section")
		switch uiType {
		case .swap:
			// set cell title
			title = "Swap \(swapDetailsVM!.fromTokenSymbol) -> \(swapDetailsVM!.toTokenSymbol)"
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
			//        case .collateral:
			//            return "Collateralized"
			//        case .un_collateral:
			//            return "Uncollateralized"
			//        case .invest:
			//            return "Invest"
			//        case .repay:
			//            return "Repaid"
			//        case .withdraw:
			//            return "Withdraw"
		}
	}
}

//
//  CoinHistoryViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Foundation

struct ActivityCellViewModel: ActivityCellViewModelProtocol {
	// MARK: - Private Properties

	private let unknownTransactionText = "Unknown transaction"
	private let unknownIcon = "unknown_transaction"
	private let swapIcon = "swap"
	private let sendIcon = "send"
	private let receiveIcon = "receive"
	private let collateralIcon = "collateral"
	private let UnCollateralIcon = "uncollateral"
	private let repaidIcon = "repaid"
	private let investIcon = "invest"
	private let withdrawIcon = "withdraw"
	private let borrowIcon = "borrow_transaction"

	private var activityModel: ActivityModel

	// MARK: - Internal Properties

	internal var globalAssetsList: [AssetViewModel] = []
	internal var activityType: ActivityType {
		if let type = ActivityType(rawValue: activityModel.type) {
			return type
		} else {
			return .other
		}
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
		case .approve:
			return .unknown
		case .other_token:
			return .unknown
		case .swap:
			return .swap
		case .other:
			return .unknown
		}
	}

	// MARK: - Public Properties

	public var formattedTime: String {
		let activityHelper = ActivityHelper()
		let dateHelper = DateHelper()
		let activityDate = activityHelper.getActivityDate(activityBlockTime: activityModel.blockTime)

		return dateHelper.calculateDistanceBetweenTwoDates(previousDate: activityDate)
	}

	public var blockTime: String {
		activityModel.blockTime
	}

	public var status: ActivityCellStatus {
		#warning("this section is mock and we should refactor this section")
		if activityModel.failed {
			return .failed
		} else {
			return .success
		}
	}

	public var icon: String {
		switch uiType {
		case .swap:
			return swapIcon
		case .borrow:
			return borrowIcon
		case .send:
			return sendIcon
		case .receive:
			return receiveIcon
		case .unknown:
			return unknownIcon
		case .collateral:
			return collateralIcon
		case .un_collateral:
			return UnCollateralIcon
		case .invest:
			return investIcon
		case .repay:
			return repaidIcon
		case .withdraw:
			return withdrawIcon
		}
	}

	public var title: String {
		#warning("this is mock and we should refactor this section")
		switch uiType {
		case .swap:
			let swapActivityVM = SwapDetailsViewModel(activityModel: activityModel, globalAssetsList: globalAssetsList)

			return "Swap \(swapActivityVM.fromTokenAmount.sevenDigitFormat) \(swapActivityVM.fromTokenSymbol) -> \(swapActivityVM.toTokenAmount.sevenDigitFormat) \(swapActivityVM.toTokenSymbol)"
		case .borrow:
			return "Borrow"
		case .send:
			let transferAcitivityDetailsVM = TransferDetailsViewModel(
				activityModel: activityModel,
				globalAssetsList: globalAssetsList
			)

			return "Send \(transferAcitivityDetailsVM.transferTokenAmount.sevenDigitFormat) \(transferAcitivityDetailsVM.transferTokenSymbol)"
		case .receive:
			let transferAcitivityDetailsVM = TransferDetailsViewModel(
				activityModel: activityModel,
				globalAssetsList: globalAssetsList
			)

			return "Received \(transferAcitivityDetailsVM.transferTokenAmount.sevenDigitFormat) \(transferAcitivityDetailsVM.transferTokenSymbol)"
		case .unknown:
			return unknownTransactionText
		case .collateral:
			return "Collateralized"
		case .un_collateral:
			return "Uncollateralized"
		case .invest:
			return "Invest"
		case .repay:
			return "Repaid"
		case .withdraw:
			return "Withdraw"
		}
	}

	public var defaultActivityModel: ActivityModel {
		activityModel
	}

	// MARK: - Initializers

	init(activityModel: ActivityModel) {
		self.activityModel = activityModel
	}

	// MARK: - Private Methods

	private func isSendTransaction() -> Bool {
		let currentAddress = PinoWalletManager().currentAccount.eip55Address
		if currentAddress.lowercased() == activityModel.detail?.from?.lowercased() {
			return true
		} else {
			return false
		}
	}
}

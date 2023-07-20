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

	internal var globalAssetsList: [AssetViewModel]
	internal var currentAddress: String
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
            
            let swapActivityVM = SwapActivityCellViewModel(activityModel: activityModel, globalAssetsList: globalAssetsList)
            
            return "Swap \(swapActivityVM.fromTokenAmount.percentFormat) \(swapActivityVM.fromTokenSymbol) -> \(swapActivityVM.toTokenAmount.percentFormat) \(swapActivityVM.toTokenSymbol)"
		case .borrow:
			return "Borrow"
		case .send:
			let sendToken = globalAssetsList?.first(where: { $0.id == activityModel.detail?.tokenID })
			return "Send \(BigNumber(number: activityModel.detail?.amount ?? "", decimal: sendToken?.decimal ?? 0).percentFormat) \(sendToken?.symbol ?? "")"
		case .receive:
			let receivedToken = globalAssetsList?.first(where: { $0.id == activityModel.detail?.tokenID })
			return "Received \(BigNumber(number: activityModel.detail?.amount ?? "", decimal: receivedToken?.decimal ?? 0).percentFormat) \(receivedToken?.symbol ?? "")"
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
    

	// MARK: - Private Methods

	private func isSendTransaction() -> Bool {
		if currentAddress == activityModel.fromAddress {
			return true
		} else {
			return false
		}
	}
}

protocol ActivitiesProtocol {
    var activityModel: ActivityModel { get set }
    var globalAssetsList: [AssetViewModel] { get }
}

struct SwapActivityCellViewModel: ActivitiesProtocol {
    
    
    var activityModel: ActivityModel
    var globalAssetsList: [AssetViewModel]

    private var fromToken: AssetViewModel? {
        globalAssetsList.first(where: { $0.id == activityModel.detail?.fromToken?.tokenID })
    }
    private var toToken: AssetViewModel? {
        globalAssetsList.first(where: { $0.id == activityModel.detail?.toToken?.tokenID })
    }
    
    public var toTokenAmount: BigNumber {
        BigNumber(number: toToken?.amount ?? "", decimal: toToken?.decimal ?? 0)
    }
    
    public var fromTokenAmount: BigNumber {
        BigNumber(number: fromToken?.amount ?? "", decimal: fromToken?.decimal ?? 0)
    }
    
    public var toTokenDecimal: Int {
        toToken?.decimal ?? 0
    }
    
    public var fromTokenDecimal: Int {
        fromToken?.decimal ?? 0
    }
    
    var toTokenSymbol: String {
        toToken?.symbol ?? ""
    }
    
    var fromTokenSymbol: String {
        fromToken?.symbol ?? ""
    }
    
}

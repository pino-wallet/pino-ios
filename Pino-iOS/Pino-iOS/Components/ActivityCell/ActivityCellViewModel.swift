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
    
    // MARK: - Internal Properties
    
    internal var activityModel: ActivityModel
    internal var currentAddress: String
    internal var activityType: ActivityType {
        if let type = ActivityType(rawValue: activityModel.type) {
            return type
        } else {
            return .other
        }
    }
    internal var uiType: ActivityCellUIType {
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
            return .swap
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let activityDate = dateFormatter.date(from: activityModel.blockTime)!
        let currentDate = Date()
        let intervalSince = currentDate.timeIntervalSince(activityDate)
        let dateComponentsformatter = DateComponentsFormatter()
        dateComponentsformatter.unitsStyle = .full
        let betweenActivityAndCurrentTime = Calendar.current.dateComponents([.day, .hour, .minute], from: activityDate, to: currentDate)
        if betweenActivityAndCurrentTime.day! > 0 {
            dateComponentsformatter.allowedUnits = [.day]
        } else if betweenActivityAndCurrentTime.hour! > 0 {
            dateComponentsformatter.allowedUnits = [.hour]
        } else {
            dateComponentsformatter.allowedUnits = [.minute]
        }
        
        return "\(dateComponentsformatter.string(from: intervalSince)!) ago"
    }
    
    public var originalTime: String {
        return activityModel.blockTime
    }
    
    public var status: ActivityCellStatus {
        #warning("this section is mock and we should refactor this section")
        return .success
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
            return "Swap"
        case .borrow:
            return "Borrow"
        case .send:
            return "Send"
        case .receive:
            return "Receive"
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
    
    public let pendingStatusText = "Pending..."
    public let failedStatusText = "Failed"
    
    // MARK: - Private Methods
    
    private func isSendTransaction() -> Bool {
        if currentAddress == activityModel.fromAddress {
            return true
        } else {
            return false
        }
    }
}

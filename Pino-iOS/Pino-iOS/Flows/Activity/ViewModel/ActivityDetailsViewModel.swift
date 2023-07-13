//
//  ActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import Foundation

class ActivityDetailsViewModel {
    // MARK: - Private Properties
    private let activityDetails: ActivityModel
   // MARK: - Public Properties
    #warning("this is for test")
    public let unVerifiedAssetIconName = "unverified_asset"
    public let pageTitle = "Activity Details"
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
    public let unknownTransactionMessage = "We do not show more details about unknown transactions. If you want, go to the Etherscan."
    public let unknownTransactionIconName = "gray_error_alert"
    #warning("tooltips are for test")
    public let feeActionSheetText = "this is fee"
    public let statusActionSheetText = "this is status"
    public let typeActionSheetText = "this is type"
    
    // header properties
    #warning("this section is mock and for test")
    public var assetIconName: String? {
     return "unverified_asset"
    }
    
    public var assetAmountTitle: String? {
        return "200 SDT"
    }
    
    public var fromTokenSymbol: String? {
        return "ETH"
    }
    
    public var toTokenSymbol: String? {
        return "USDC"
    }
    
    public var fromTokenImageName: String? {
        return "cETH"
    }
    
    public var toTokenImageName: String? {
        return "USDC"
    }
    
    public var fromTokenAmount: String? {
        return "0.5"
    }
    
    public var toTokenAmount: String? {
        return "1100"
    }
    
    // information properties
    public var formattedDate: String {
        return "2 days ago"
    }
    
    public var fullFormattedDate: String {
        return "May-19-2023 08:41:11 AM +UTC"
    }
    
    public var protocolName: String? {
        return "Uniswap"
    }
    
    public var protocolImage: String? {
        return "1inch"
    }
    
    public var feeInDollar: String {
        return "$2"
    }
    
    public var feeInToken: String {
        return "1 UNI"
    }
    
    public var status: ActivityStatus {
        return ActivityStatus.complete
    }
    
    public var typeName: String {
        return "Borrow"
    }
    
    public var fromAddress: String? {
        return "0x7840fD13A8237C08A258DDd982D369acA81388A3"
    }
    
    public var toAddress: String? {
        return "0x7840fD13A8237C08A258DDd982D369acA81388A3"
    }
    
    public var fromIcon: String? {
        return "avocado"
    }
    
    public var toIcon: String? {
        return "avocado"
    }
    
    public var fromName: String? {
        return "Amir"
    }
    
    public var toName: String? {
        return "Amir"
    }
    
    public var uiType: ActivityUIType {
        return .send
    }
    
    // MARK: - Initializers
    init(activityDetails: ActivityModel) {
        self.activityDetails = activityDetails
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

//
//  LoanDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import Foundation

struct CollateralDetailsViewModel {
	// MARK: - Public Properties
    
    
    public let freeTitle = "Free"
    public let involvedTitle = "Involved"
    public let totalCollateralTitle = "Total collateral"
    public let increaseLoanTitle = "Increase collateral"
    public let withdrawTitle = "Withdraw"
	public let dismissIconName = "dissmiss"
    public let collateralledTokenModel: UserBorrowingToken
    
    
    
    public var pageTitle: String {
        "\(foundTokenInManageAssetTokens.symbol) collateral details"
    }
    public var tokenCollateralAmountAndSymbol: String {
        userAmountInToken.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
    }
    public var totalTokenAmountInDollar: String {
        let userAmountInDollars = userAmountInToken * foundTokenInManageAssetTokens.price
        return userAmountInDollars.priceFormat
    }
    public var tokenIcon: URL {
        foundTokenInManageAssetTokens.image
    }
    public var totalCollateral: String {
        userAmountInToken.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
    }
    #warning("this is mock")
	public let involvedAmountInToken = "15 LINK"
	public let freeAmountInToken = "340 LINK"
    
    // MARK: - Private Properties
    
    private var foundTokenInManageAssetTokens: AssetViewModel {
        (GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == collateralledTokenModel.id }))!
    }
    private var userAmountInToken: BigNumber {
        BigNumber(number: collateralledTokenModel.amount, decimal: foundTokenInManageAssetTokens.decimal)
    }
    
    
    // MARK: - Initializers
    init(collateralledTokenModel: UserBorrowingToken) {
        self.collateralledTokenModel = collateralledTokenModel
    }
}

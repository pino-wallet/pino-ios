//
//  UserBorrowingAssetCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

class UserBorrowingAssetCell: AssetsBoardCell {
   // MARK: - Public Properties
    public static let cellReuseID = "userBorrowingCellReuseID"
    
    public var userBorrowingAssetVM: UserBorrowingAssetViewModel! {
        didSet {
            asset = userBorrowingAssetVM
            setCellValues()
        }
    }
    
    // MARK: - Private Methods
    private func setCellValues() {
        assetAmountLabel.text = userBorrowingAssetVM.userBorrowingInToken
        assetAmountLabel.textColor = .Pino.label
        
        assetAmountDescriptionLabel.text = userBorrowingAssetVM.userBorrowingInDollars
        assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel
    }
}

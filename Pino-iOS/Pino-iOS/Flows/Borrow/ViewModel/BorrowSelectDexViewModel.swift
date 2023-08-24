//
//  BorrowSelectDexViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation


struct BorrowSelectDexViewModel: SelectDexSystemVMProtocol {
   // MARK: - Public Properties
    public let dexSystemList: [DexSystemModel] = [.aave, .compound]
    public let pageTitle = "Select dex"
    public let dissmissButtonImageName = "dissmiss"
}

//
//  CreateImportOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

struct AddNewWalletOptionViewModel {
    public let AddNewWalletOption: AddNewWalletOptionModel
    
    public var title: String {
        return AddNewWalletOption.title
    }
    public var description: String {
        return AddNewWalletOption.descrption
    }
    public var iconName: String {
        return AddNewWalletOption.iconName
    }
    public var page: AddNewWalletOptionModel.page {
        return AddNewWalletOption.page
    }
}

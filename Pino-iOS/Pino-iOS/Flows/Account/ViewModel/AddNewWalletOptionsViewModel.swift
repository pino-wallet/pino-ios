//
//  AddNewWalletOptionsViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//
class AddNewWalletViewModel {
    public let AddNewWalletOptions: [AddNewWalletOptionModel?] = [
        AddNewWalletOptionModel(title: "Create a new wallet", descrption: "Generate a new account", iconName: "arrow_right", page: .Create),
        AddNewWalletOptionModel(title: "Import wallet", descrption: "Import an existing wallet", iconName: "arrow_right", page: .Import)
    ]
}

//
//  UserAccountInfoViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/23/24.
//

import Foundation

struct UserAccountInfoViewModel {
	// MARK: - Public Properties

	public let accountIconName: String?
	public let accountIconColorName: String?
	public let accountName: String
	public let accountAddress: String

	init(accountInfoVM: AccountInfoViewModel) {
		self.accountName = accountInfoVM.name
		self.accountAddress = accountInfoVM.address
		self.accountIconName = accountInfoVM.profileImage
		self.accountIconColorName = accountInfoVM.profileColor
	}

	init(ensAddressInfo: RecipientENSInfo) {
		self.accountName = ensAddressInfo.name
		self.accountAddress = ensAddressInfo.address
		self.accountIconName = nil
		self.accountIconColorName = nil
	}
}

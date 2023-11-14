//
//  TransferDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

import Foundation

struct TransferActivityDetailsViewModel: ActivityCellDetailsProtocol {
	// MARK: - TypeAliases

	typealias UserAccountInfoType = (image: String, name: String)

	// MARK: - Internal Properties

	internal var activityModel: ActivityTransferModel

	internal var token: AssetViewModel

	// MARK: - Private Properties

	private var transferTokenDecimal: Int {
		token.decimal
	}

	// MARK: - Public Properties

	public var transferTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.amount, decimal: transferTokenDecimal)
	}

	public var transferFromAddress: String {
		activityModel.fromAddress.shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
	}

	public var transferToAddress: String {
		activityModel.toAddress.shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
	}

	public var userFromAccountInfo: UserAccountInfoType? {
		getUserAccountInfoBy(address: activityModel.detail.from)
	}

	public var userToAccountInfo: UserAccountInfoType? {
		getUserAccountInfoBy(address: activityModel.detail.to)
	}

	// MARK: - Private Methods

	private func getUserAccountInfoBy(address: String) -> UserAccountInfoType? {
		let walletManager = PinoWalletManager()
		let foundUserAccount = walletManager.accounts
			.first(where: { $0.eip55Address.lowercased() == address.lowercased() })

		if foundUserAccount != nil {
			return (image: foundUserAccount!.avatarIcon, name: foundUserAccount!.name)
		}
		return nil
	}
}

//
//  TransferDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

import Foundation

struct TransferDetailsViewModel: ActivityDetailsProtocol {
	// MARK: - TypeAliases

	typealias UserAccountInfoType = (image: String, name: String)

	// MARK: - Internal Properties

	internal var activityModel: ActivityModel
	internal var globalAssetsList: [AssetViewModel]

	// MARK: - Private Properties

	private var transferToken: AssetViewModel? {
		globalAssetsList.first(where: { $0.id == activityModel.detail?.tokenID })
	}

	private var transferTokenDecimal: Int {
		transferToken?.decimal ?? 0
	}

	// MARK: - Public Properties

	public var transferTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail?.amount ?? "", decimal: transferTokenDecimal)
	}

	public var transferTokenSymbol: String {
		transferToken?.symbol ?? ""
	}

	public var transferTokenImage: URL? {
		transferToken?.image
	}

	public var transferFromAddress: String {
		activityModel.fromAddress.shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
	}

	public var transferToAddress: String {
		activityModel.toAddress.shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
	}

	public var userFromAccountInfo: UserAccountInfoType? {
		getUserAccountInfoBy(address: activityModel.detail?.from ?? "")
	}

	public var userToAccountInfo: UserAccountInfoType? {
		getUserAccountInfoBy(address: activityModel.detail?.to ?? "")
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

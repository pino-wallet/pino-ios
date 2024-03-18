//
//  SendRecipientAddress.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/24/24.
//

import Foundation

enum SendRecipientAddress {
	case regularAddress(String)
	case ensAddress(RecipientENSInfo)
	case userWalletAddress(AccountInfoViewModel)

	public var address: String {
		switch self {
		case let .regularAddress(address):
			return address
		case let .ensAddress(recipientENSInfo):
			return recipientENSInfo.address
		case let .userWalletAddress(accountInfoViewModel):
			return accountInfoViewModel.address
		}
	}

	public var name: String? {
		switch self {
		case .regularAddress:
			return nil
		case let .ensAddress(recipientENSInfo):
			return recipientENSInfo.name
		case let .userWalletAddress(accountInfoViewModel):
			return accountInfoViewModel.name
		}
	}

	public var ensName: String? {
		switch self {
		case .regularAddress, .userWalletAddress:
			return nil
		case let .ensAddress(recipientENSInfo):
			return recipientENSInfo.name
		}
	}
}

struct RecipientENSInfo {
	public let name: String
	public let address: String
}

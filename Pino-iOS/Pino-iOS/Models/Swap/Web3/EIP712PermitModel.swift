//
//  EIP712PermitModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import BigInt
import Foundation

// MARK: - Welcome

struct EIP712PermitModel: Codable {
	// MARK: - Internal Properties

	let types: Types
	let primaryType: String
	let domain: Domain
	let message: Message

	// MARK: - Initializers

	init(tokenAdd: String, amount: String, spender: String, nonce: String, deadline: String) {
		let eip712Domain: [DomainType] = [
			.init(name: "name", type: "string"),
			.init(name: "chainId", type: "uint256"),
			.init(name: "verifyingContract", type: "address"),
		]
		let permitTransferFrom: [DomainType] = [
			.init(name: "permitted", type: "TokenPermissions"),
			.init(name: "spender", type: "address"),
			.init(name: "nonce", type: "uint256"),
			.init(name: "deadline", type: "uint256"),
		]
		let tokenPermissions: [DomainType] = [
			.init(name: "token", type: "address"),
			.init(name: "amount", type: "uint256"),
		]

		let initTypes = Types(
			eip712Domain: eip712Domain,
			permitTransferFrom: permitTransferFrom,
			tokenPermissions: tokenPermissions
		)
		let initDomain = Domain(
			name: "Permit2",
			chainID: Int(Web3Core.Constants.mainNetChainID.quantity),
			verifyingContract: "0x000000000022d473030f116ddee9f6b43ac78ba3"
		)
		let initPermit = Permitted(token: tokenAdd, amount: amount)
		let initMessage = Message(
			permitted: initPermit,
			spender: Web3Core.Constants.pinoProxyAddress,
			nonce: nonce,
			deadline: deadline
		)

		self.types = initTypes
		self.primaryType = "PermitTransferFrom"
		self.message = initMessage
		self.domain = initDomain
	}
}

extension EIP712PermitModel {
	// MARK: - Domain

	struct Domain: Codable {
		let name: String
		let chainID: Int
		let verifyingContract: String

		enum CodingKeys: String, CodingKey {
			case name
			case chainID = "chainId"
			case verifyingContract
		}
	}

	// MARK: - Message

	struct Message: Codable {
		let permitted: Permitted
		let spender: String
		let nonce: String
		let deadline: String
	}

	// MARK: - Permitted

	struct Permitted: Codable {
		let token, amount: String
	}

	// MARK: - Types

	struct Types: Codable {
		let eip712Domain, permitTransferFrom, tokenPermissions: [DomainType]

		enum CodingKeys: String, CodingKey {
			case eip712Domain = "EIP712Domain"
			case permitTransferFrom = "PermitTransferFrom"
			case tokenPermissions = "TokenPermissions"
		}
	}

	// MARK: - Eip712Domain

	struct DomainType: Codable {
		let name, type: String
	}
}

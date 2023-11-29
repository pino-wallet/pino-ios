//
//  AccountActivationModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/4/23.
//

import BigInt
import Combine
import Foundation
import Web3

// MARK: - AccountActivationModel

struct AccountActivationRequestModel: Codable {
	let address, sig: String
	let time: BigUInt

	// MARK: - Public Properties

	public var reqBody: BodyParamsType {
		let params: HTTPParameters = [
			"Name": address,
			"sig": sig,
			"time": "\(time)",
		]
		return BodyParamsType.json(params)
	}

	// MARK: - Public Methods

	public static func activationHashType(userAddress: String, createdTime: BigUInt) -> BodyParamsType {
		let typedData: [String: Any] = [
			"Types": [
				"ActivationRequest": [
					["Name": "address", "Type": "string"],
					["Name": "time", "Type": "string"],
				],
				"EIP712Domain": [
					["Name": "name", "Type": "string"],
					["Name": "version", "Type": "string"],
					["Name": "chainId", "Type": "uint256"],
					["Name": "verifyingContract", "Type": "address"],
				],
			],
			"PrimaryType": "ActivationRequest",
			"Domain": [
				"ChainId": 1,
				"Name": "pino",
				"VerifyingContract": "0x0000000000000000000000000000000000000000",
				"Version": "1",
			],
			"Message": [
				"address": userAddress,
				"time": "\(createdTime)",
			],
		]
		return BodyParamsType.json(typedData)
	}
}

struct AccountActivationModel: Codable {
	let id: String
}

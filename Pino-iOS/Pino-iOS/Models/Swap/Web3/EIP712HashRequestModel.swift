//
//  EIP712HashData.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import Foundation

struct EIP712HashRequestModel: Codable {
	let tokenAdd: String
	let amount: String
	let spender: String
	let nonce: String
	let deadline: String

	public var eip712HashReqBody: BodyParamsType {
		let permitEIP712Model = EIP712PermitModel(
			tokenAdd: tokenAdd,
			amount: amount,
			spender: spender,
			nonce: nonce,
			deadline: deadline
		)

		let jsonEncoder = JSONEncoder()
		let typesData = try! jsonEncoder.encode(permitEIP712Model.types)
		let domainData = try! jsonEncoder.encode(permitEIP712Model.domain)
		let messageData = try! jsonEncoder.encode(permitEIP712Model.message)

		let typesJSON = try! JSONSerialization.jsonObject(with: typesData, options: []) as? HTTPParameters
		let domainJSON = try! JSONSerialization.jsonObject(with: domainData, options: []) as? HTTPParameters
		let messageJSON = try! JSONSerialization.jsonObject(with: messageData, options: []) as? HTTPParameters

		let params: HTTPParameters = [
			"types": typesJSON!,
			"primaryType": permitEIP712Model.primaryType,
			"domain": domainJSON!,
			"message": messageJSON!,
		]
		return BodyParamsType.json(params)
	}
}

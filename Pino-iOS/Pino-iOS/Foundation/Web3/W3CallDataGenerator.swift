//
//  W3CallDataGenerator.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/26/23.
//

import Foundation

struct W3CallDataGenerator {
	public static func generateMultiCallFrom(calls: [String]) -> String {
		let calls = calls.map { $0.replacingOccurrences(of: "0x", with: "") }
		let filledCalls = calls.map { callData in
			let remain = callData.count % 64

			if remain != 0 {
				return callData.paddingRight(count: 64 - remain, withPad: "0")
			}
			return callData
		}

		let lengthCalls = filledCalls.map { call in call.count / 64 }

		var multicall = [String]()

		multicall.append("0x57aca4f1") // signatrue
		multicall.append(
			"0000000000000000000000000000000000000000000000000000000000000040"
		) // offset
		multicall.append(
			"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" +
				"\(calls.count)"
		) // len

		for (i, _) in calls.enumerated() {
			let lines = calls.count
			var offsetLines = 0
			for j in 0 ..< i {
				offsetLines += (lengthCalls[j] + 1) * 32
			}

			let offset = String(lines * 32 + offsetLines, radix: 16)
			multicall.append(offset.paddingLeft(toLength: 64, withPad: "0"))
		}

		for i in 0 ..< calls.count {
			multicall.append(String(calls[i].count / 2, radix: 16).paddingLeft(toLength: 64, withPad: "0"))
			multicall.append(filledCalls[i])
		}

		return multicall.reduce("") { partialResult, nexStr in
			partialResult + nexStr
		}
	}
}

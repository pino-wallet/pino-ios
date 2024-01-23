//
//  StringProtocol+Extension.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation
import PromiseKit
import UIKit
import Web3

extension String {
	var toArray: [String] {
		var array: [String] = []
		enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
			array.append(
				String(self[range])
			)
		}
		return array
	}

	var doubleValue: Double? {
		Double(self)
	}

	public func shortenedString(characterCountFromStart: Int, characterCountFromEnd: Int?) -> String {
		if characterCountFromEnd != nil {
			return "\(prefix(characterCountFromStart))...\(suffix(characterCountFromEnd!))"
		}
		return "\(prefix(characterCountFromStart))..."
	}

	public func addressFormating() -> String {
		shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
	}

	public func addressFromStartFormatting() -> String {
		shortenedString(characterCountFromStart: 6, characterCountFromEnd: nil)
	}

	public func validateETHContractAddress() -> Bool {
		let ethAddressRegex = "^0x[0-9a-fA-F]{40}$"
		if range(of: ethAddressRegex, options: .regularExpression, range: nil, locale: nil) != nil {
			return true
		} else {
			return false
		}
	}

	public func isENSAddress() -> Bool {
		let ethAddressRegex = "^0x[0-9a-fA-F]{40}$"
		if range(of: ethAddressRegex, options: .regularExpression, range: nil, locale: nil) != nil {
			return true
		} else {
			return false
		}
	}

	public func generateQRCode(customHeight: Int, customWidth: Int) -> UIImage? {
		let data = data(using: String.Encoding.ascii)
		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(data, forKey: "inputMessage")
			// L: 7%, M: 15%, Q: 25%, H: 30%
			filter.setValue("M", forKey: "inputCorrectionLevel")

			if let qrImage = filter.outputImage {
				let scaleX = CGFloat(customWidth) / qrImage.extent.size.width
				let scaleY = CGFloat(customHeight) / qrImage.extent.size.height
				let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
				let output = qrImage.transformed(by: transform)
				return UIImage(ciImage: output)
			}
		}

		return nil
	}

	public var utf8Data: Data {
		data(using: .utf8)!
	}

	public static var emptyString: Self {
		""
	}

	public var trimmCurrency: Self {
		if contains("$") {
			var trimmedStr = self
			trimmedStr.removeAll(where: { $0.description == self.currentCurrency })
			return trimmedStr
		} else {
			return self
		}
	}

	public var trimmSeperators: Self {
		let locale = Locale.current
		let decimalSeparator = locale.decimalSeparator ?? "."
		let groupingSeparator = locale.groupingSeparator ?? ","

		if decimalSeparator != groupingSeparator {
			return replacingOccurrences(of: groupingSeparator, with: "")
		} else {
			// Handle the case where the decimal and grouping separators are the same
			// Example: Return the string as is, or implement alternative logic
			return self
		}
	}

	public var promise: Promise<Self> {
		Promise<Self> { seal in
			seal.fulfill(self)
		}
	}

	public var eip55Address: EthereumAddress? {
		do {
			return try EthereumAddress(hex: Web3Core.shared.getChecksumOfEip55Address(eip55Address: self), eip55: true)
		} catch {
			return nil
		}
	}

	public func paddingLeft(toLength: Int, withPad: String) -> String {
		let paddingCount = toLength - count
		guard paddingCount > 0 else { return self }

		let padding = String(repeating: withPad, count: paddingCount)
		return padding + self
	}

	public func paddingRight(toLength: Int, withPad: String) -> String {
		let paddingCount = toLength - count
		guard paddingCount > 0 else { return self }

		let padding = String(repeating: withPad, count: paddingCount)
		return self + padding
	}

	func paddingRight(count: Int, withPad: String) -> String {
		let padding = String(repeating: withPad, count: count)
		return self + padding
	}

	public var bigUInt: BigUInt? {
		do {
			let bigNum = try BigUInt(self)
			return bigNum
		} catch {
			return nil
		}
	}

	public var ethScanTxURL: String {
		"http://www.etherscan.io/tx/\(self)"
	}

	public var formattedNumberWithCamma: String {
		var tokenAmountNumbersArray: [String]
		var tokenAmountDecimals: String?
		if contains(".") {
			let splittedTokenAmountArray = components(separatedBy: ".")
			tokenAmountNumbersArray = Array(splittedTokenAmountArray[0]).map { String($0) }
			tokenAmountDecimals = splittedTokenAmountArray[1]
		} else {
			tokenAmountNumbersArray = Array(self).map { String($0) }
		}
		var reversedArray = Array(tokenAmountNumbersArray.reversed())

		var numberOfCammas = 0
		for (index, _) in reversedArray.enumerated() {
			let indexOfCamma = index + 1
			if indexOfCamma % 3 == 0 && indexOfCamma < (reversedArray.count - numberOfCammas) {
				reversedArray.insert(",", at: indexOfCamma + numberOfCammas)
				numberOfCammas = numberOfCammas + 1
			}
		}
		let result = Array(reversedArray.reversed()).joined(separator: "")
		if let tokenAmountDecimals {
			return result + "." + tokenAmountDecimals
		} else {
			return result
		}
	}
}

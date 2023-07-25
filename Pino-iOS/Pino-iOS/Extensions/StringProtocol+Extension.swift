//
//  StringProtocol+Extension.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation
import UIKit

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

	public func shortEndString(characterCountFromStart: Int, characterCountFromEnd: Int) -> String {
		"\(prefix(characterCountFromStart))...\(suffix(characterCountFromEnd))"
	}
    
    public func shortAddressFormating() -> String {
        self.shortEndString(characterCountFromStart: 4, characterCountFromEnd: 4)
    }
    
    public func mediumAddressFormating() -> String {
        self.shortEndString(characterCountFromStart: 6, characterCountFromEnd: 4)
    }

	public func validateETHContractAddress() -> Bool {
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
}

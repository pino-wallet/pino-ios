//
//  CIImage.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/27/23.
//
// Source = https://www.avanderlee.com/swift/qr-code-generation-swift/

import UIKit

extension CIImage {
	/// Inverts the colors and creates a transparent image by converting the mask to alpha.
	/// Input image should be black and white.
	var transparent: CIImage? {
		inverted?.blackTransparent
	}

	/// Inverts the colors.
	var inverted: CIImage? {
		guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

		invertedColorFilter.setValue(self, forKey: "inputImage")
		return invertedColorFilter.outputImage
	}

	/// Converts all black to transparent.
	var blackTransparent: CIImage? {
		guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
		blackTransparentFilter.setValue(self, forKey: "inputImage")
		return blackTransparentFilter.outputImage
	}

	/// Applies the given color as a tint color.
	func tinted(using color: UIColor) -> CIImage? {
		guard let transparentQRImage = transparent,
		      let filter = CIFilter(name: "CIMultiplyCompositing"),
		      let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

		let ciColor = CIColor(color: color)
		colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
		let colorImage = colorFilter.outputImage

		filter.setValue(colorImage, forKey: kCIInputImageKey)
		filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

		return filter.outputImage!
	}
}

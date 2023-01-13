//
//  Button+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/25/22.
//

import UIKit

extension UIButton {
	public func setConfiguraton(font: UIFont, imagePadding: CGFloat = 0, titlePadding: CGFloat = 0) {
		var buttonConfiguration = UIButton.Configuration.plain()

		buttonConfiguration.imagePadding = imagePadding
		buttonConfiguration.titlePadding = titlePadding

		buttonConfiguration.titleTextAttributesTransformer =
			UIConfigurationTextAttributesTransformer { config in
				var buttonConfig = config
				buttonConfig.font = font
				return buttonConfig
			}

		configuration = buttonConfiguration
	}
}

//
//  HomepageFooterView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//

import UIKit

class HomepageFooterView: UICollectionReusableView {
	// MARK: - Private Properties

	private var manageAssetButton = UIButton()

	// MARK: - Public Properties

	public static let footerReuseID = "homepageFooter"

	public var title: String! {
		didSet {
			setupManageAssetView(title)
		}
	}

	// MARK: - Private Methods

	private func setupManageAssetView(_ title: String) {
		addSubview(manageAssetButton)

		manageAssetButton.setTitle(title, for: .normal)
		manageAssetButton.setImage(UIImage(named: "manage_asset"), for: .normal)
		manageAssetButton.setTitleColor(.Pino.primary, for: .normal)
		manageAssetButton.configuration = .plain()
		manageAssetButton.configuration?.imagePadding = 6
		manageAssetButton.configuration?.titleTextAttributesTransformer =
			UIConfigurationTextAttributesTransformer { btnConfig in
				var sendButtonConfig = btnConfig
				sendButtonConfig.font = UIFont.PinoStyle.mediumCallout
				return sendButtonConfig
			}

		manageAssetButton.pin(
			.centerY,
			.centerX
		)
	}
}

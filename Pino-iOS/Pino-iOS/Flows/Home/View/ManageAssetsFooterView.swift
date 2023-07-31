//
//  HomepageFooterView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//

import UIKit

class ManageAssetsFooterView: UICollectionReusableView {
	// MARK: - Public Properties

	public static let footerReuseID = "homepageFooter"
	public var manageAssetButton = UIButton()
	public var title: String! {
		didSet {
			setupManageAssetView(title)
		}
	}

	// MARK: - Private Methods

	private func setupManageAssetView(_ title: String) {
		addSubview(manageAssetButton)

		backgroundColor = .Pino.background
		manageAssetButton.setTitle(title, for: .normal)
		manageAssetButton.setImage(UIImage(named: "manage_asset"), for: .normal)
		manageAssetButton.setTitleColor(.Pino.primary, for: .normal)
		manageAssetButton.setConfiguraton(font: .PinoStyle.mediumCallout!, imagePadding: 6)

		manageAssetButton.pin(
			.top(padding: 32),
			.centerX
		)
	}
}

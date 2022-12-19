//
//  HomepageNavigationBar.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import UIKit

struct HomepageNavigationItems {
	// MARK: - Private Properties

	private var walletName: String
	private var walletAddress: String
	private var manageAssetIcon: String
	private var profileIcon: String

	// MARK: - Initializers

	init(walletName: String, walletAddress: String, manageAssetIcon: String, profileIcon: String) {
		self.walletName = walletName
		self.walletAddress = walletAddress
		self.manageAssetIcon = manageAssetIcon
		self.profileIcon = profileIcon
	}

	// MARK: - Public Properties

	public var walletTitle: UIButton {
		let walletName = NSMutableAttributedString(
			string: walletName,
			attributes: [
				NSAttributedString.Key.foregroundColor: UIColor.Pino.label,
				NSAttributedString.Key.font: UIFont.PinoStyle.mediumCallout!,
			]
		)

		let walletAddress = NSMutableAttributedString(
			string: "(\(walletAddress.prefix(3))...\(walletAddress.suffix(3)))",
			attributes: [
				NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel,
				NSAttributedString.Key.font: UIFont.PinoStyle.regularCallout!,
			]
		)

		walletName.append(walletAddress)

		let navigationBarTitle = UIButton()
		navigationBarTitle.setAttributedTitle(walletName, for: .normal)

		return navigationBarTitle
	}

	public var manageAssetButton: UIBarButtonItem {
		let manageAssetButton = UIBarButtonItem(
			image: UIImage(named: manageAssetIcon),
			style: .plain,
			target: nil,
			action: nil
		)

		manageAssetButton.tintColor = .Pino.primary

		return manageAssetButton
	}

	public var profileButton: UIBarButtonItem {
		let profileButton = UIButton()
		profileButton.setImage(UIImage(named: profileIcon), for: .normal)
		profileButton.backgroundColor = .Pino.green1
		profileButton.pin(.fixedWidth(32), .fixedHeight(32))
		profileButton.layer.cornerRadius = 16

		let navigationBarButton = UIBarButtonItem()
		navigationBarButton.customView = profileButton

		return navigationBarButton
	}
}

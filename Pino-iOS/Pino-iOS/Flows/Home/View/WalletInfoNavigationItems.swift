//
//  HomepageNavigationBar.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import UIKit

struct WalletInfoNavigationItems {
	// MARK: - Private Properties

	private var walletInfoVM: WalletInfoViewModel

	// MARK: - Initializers

	init(walletInfoVM: WalletInfoViewModel) {
		self.walletInfoVM = walletInfoVM
	}

	// MARK: - Public Properties

	public var walletTitle: UIButton {
		let walletName = NSMutableAttributedString(
			string: walletInfoVM.name,
			attributes: [
				NSAttributedString.Key.foregroundColor: UIColor.Pino.label,
				NSAttributedString.Key.font: UIFont.PinoStyle.mediumCallout!,
			]
		)

		let walletAddress = NSMutableAttributedString(
			string: "(\(walletInfoVM.address.prefix(3))...\(walletInfoVM.address.suffix(3)))",
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

	public var profileButton: UIBarButtonItem {
		let profileButton = UIButton()
		profileButton.setImage(UIImage(named: walletInfoVM.profileImage), for: .normal)
		profileButton.backgroundColor = UIColor(named: walletInfoVM.profileColor)
		profileButton.pin(.fixedWidth(32), .fixedHeight(32))
		profileButton.layer.cornerRadius = 16

		let navigationBarButton = UIBarButtonItem()
		navigationBarButton.customView = profileButton

		return navigationBarButton
	}

	public static var manageAssetButton: UIBarButtonItem {
		let manageAssetButton = UIBarButtonItem(
			image: UIImage(named: "manage_asset"),
			style: .plain,
			target: nil,
			action: nil
		)

		manageAssetButton.tintColor = .Pino.primary

		return manageAssetButton
	}
}

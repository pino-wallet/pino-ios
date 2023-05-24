//
//  HomepageNavigationBar.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import UIKit

struct AccountInfoNavigationItems {
	// MARK: - Private Properties

	private var accountInfoVM: AccountInfoViewModel

	// MARK: - Initializers

	init(accountInfoVM: AccountInfoViewModel) {
		self.accountInfoVM = accountInfoVM
	}

	// MARK: - Public Properties

	public var accountTitle: UIButton {
		let accountName = NSMutableAttributedString(
			string: accountInfoVM.name,
			attributes: [
				NSAttributedString.Key.foregroundColor: UIColor.Pino.label,
				NSAttributedString.Key.font: UIFont.PinoStyle.mediumCallout!,
			]
		)

		let accountAddress = NSMutableAttributedString(
			string: " (\(accountInfoVM.address.shortenedString(characterCount: 3)))",
			attributes: [
				NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel,
				NSAttributedString.Key.font: UIFont.PinoStyle.mediumCallout!,
			]
		)

		accountName.append(accountAddress)

		let navigationBarTitle = UIButton()
		navigationBarTitle.setAttributedTitle(accountName, for: .normal)

		return navigationBarTitle
	}

	public var profileButton: UIBarButtonItem {
		let profileButton = UIButton()
		profileButton.setImage(UIImage(named: accountInfoVM.profileImage), for: .normal)
		profileButton.backgroundColor = UIColor(named: accountInfoVM.profileColor)
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

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

	public var accountTitle: UIStackView {
        let navigationBarTitleStackView = UIStackView()
        let accountNameLabel = PinoLabel(style: .info, text: "")
        let accountImageViewContainer = UIView()
        let accountImageView = UIImageView()
        let arrowDownImageView = UIImageView()
        
        accountImageViewContainer.addSubview(accountImageView)
        navigationBarTitleStackView.addArrangedSubview(accountImageViewContainer)
        navigationBarTitleStackView.addArrangedSubview(accountNameLabel)
        navigationBarTitleStackView.addArrangedSubview(arrowDownImageView)
        
        navigationBarTitleStackView.axis = .horizontal
        navigationBarTitleStackView.spacing = 4
        navigationBarTitleStackView.alignment = .center
        accountNameLabel.font = .PinoStyle.semiboldCallout
        accountNameLabel.text = accountInfoVM.name
        accountImageViewContainer.layer.cornerRadius = 13
        accountImageViewContainer.backgroundColor = UIColor(named: accountInfoVM.profileColor)
        arrowDownImageView.image = UIImage(named: "arrow_down_home")
        accountImageView.image = UIImage(named: accountInfoVM.profileImage)
        
        accountImageViewContainer.pin(.fixedWidth(26), .fixedHeight(26))
        accountImageView.pin(.fixedWidth(18), .fixedHeight(18), .centerX, .centerY)
        arrowDownImageView.pin(.fixedWidth(18), .fixedHeight(18))
        
		return navigationBarTitleStackView
	}

	public var profileButton: UIBarButtonItem {
		let profileButton = UIButton()
		profileButton.setImage(UIImage(named: "settings_home"), for: .normal)
		profileButton.pin(.fixedWidth(24), .fixedHeight(24))
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

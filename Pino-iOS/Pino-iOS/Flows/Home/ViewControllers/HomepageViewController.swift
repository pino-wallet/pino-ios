//
//  HomepageViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class HomepageViewController: UIViewController {
	// MARK: - Private Properties

	private var addressCopiedToastView: PinoToastView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
		setupToastView()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = HomepageView()
	}

	private func setupNavigationBar() {
		let homepageNavigationItems = HomepageNavigationItems(
			walletName: "Amir",
			walletAddress: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			manageAssetIcon: "manage_asset",
			profileIcon: "avocado"
		)

		navigationItem.rightBarButtonItem = homepageNavigationItems.manageAssetButton
		navigationItem.leftBarButtonItem = homepageNavigationItems.profileButton
		navigationItem.titleView = homepageNavigationItems.walletTitle

		(navigationItem.titleView as? UIButton)?.addAction(UIAction(handler: { _ in
			self.copyWalletAddress()
		}), for: .touchUpInside)
	}

	private func setupToastView() {
		addressCopiedToastView = PinoToastView(message: "Copied!")
		view.addSubview(addressCopiedToastView)

		addressCopiedToastView.pin(
			.top(to: view.layoutMarginsGuide),
			.centerX
		)
	}

	private func copyWalletAddress() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = "gf4bh5n3m2c8l4j5w9i2l6t2de"

		addressCopiedToastView.showToast()
	}
}

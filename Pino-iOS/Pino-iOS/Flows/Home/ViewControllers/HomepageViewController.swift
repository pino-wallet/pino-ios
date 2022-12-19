//
//  HomepageViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class HomepageViewController: UIViewController {
	// MARK: - Private Properties

	let copyToastView = UIView()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = HomepageView()
		setupToastView()
	}

	private func setupToastView() {
		let copyLabel = UILabel()

		copyToastView.addSubview(copyLabel)
		view.addSubview(copyToastView)

		copyLabel.text = "Copied!"
		copyLabel.textColor = .Pino.white
		copyLabel.font = .PinoStyle.semiboldFootnote

		copyToastView.backgroundColor = .Pino.primary
		copyToastView.layer.cornerRadius = 14

		copyToastView.pin(
			.fixedHeight(28),
			.top(to: view.layoutMarginsGuide),
			.centerX
		)
		copyLabel.pin(
			.centerY,
			.horizontalEdges(padding: 12)
		)

		copyToastView.alpha = 0
	}

	private func setupNavigationBar() {
		setupNavigationtitle()
		setupManageAssetButton()
		setupProfileButton()
	}
}

extension HomepageViewController {
	// MARK: - Navigation Bar Private Methods

	private func setupNavigationtitle() {
		let address = "gf4bh5n3m2c8l4j5w9i2l6t2de"
		let walletName = NSMutableAttributedString(string: "Amir", attributes: [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.label,
			NSAttributedString.Key.font: UIFont.PinoStyle.mediumCallout!])

		let walletAddress = NSMutableAttributedString(
			string: "(\(address.prefix(3))...\(address.suffix(3)))",
			attributes: [
				NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel,
				NSAttributedString.Key.font: UIFont.PinoStyle.regularCallout!,
			]
		)

		walletName.append(walletAddress)

		let navigationBarTitle = UIButton()
		navigationBarTitle.setAttributedTitle(walletName, for: .normal)
		navigationBarTitle.addAction(UIAction(handler: { _ in
			self.copyWalletAddress(address)
		}), for: .touchUpInside)

		navigationItem.titleView = navigationBarTitle
	}

	private func setupManageAssetButton() {
		let manageAssetButton = UIBarButtonItem(
			image: UIImage(named: "manage_asset"),
			style: .plain,
			target: nil,
			action: nil
		)
		navigationItem.rightBarButtonItem = manageAssetButton
		navigationItem.rightBarButtonItem?.tintColor = .Pino.primary
	}

	private func setupProfileButton() {
		let profileButton = UIButton()
		profileButton.setImage(UIImage(named: "avocado"), for: .normal)
		profileButton.backgroundColor = .Pino.green1
		profileButton.pin(.fixedWidth(32), .fixedHeight(32))
		profileButton.layer.cornerRadius = 16

		navigationItem.leftBarButtonItem = UIBarButtonItem()
		navigationItem.leftBarButtonItem?.customView = profileButton
	}

	private func copyWalletAddress(_ address: String) {
		let pasteboard = UIPasteboard.general
		pasteboard.string = address

		UIView.animate(withDuration: 0.5) { [weak self] in
			self?.copyToastView.alpha = 1
		}

		UIView.animate(withDuration: 0.5, delay: 2) { [weak self] in
			self?.copyToastView.alpha = 0
		}
	}
}

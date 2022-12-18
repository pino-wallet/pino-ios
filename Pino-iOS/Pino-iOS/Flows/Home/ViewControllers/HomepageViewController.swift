//
//  HomepageViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class HomepageViewController: UIViewController {
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
	}

	private func setupNavigationBar() {
		setupNavigationtitle()
		let manageAssetButton = UIBarButtonItem(
			image: UIImage(named: "manage_asset"),
			style: .plain,
			target: nil,
			action: nil
		)
		navigationItem.rightBarButtonItem = manageAssetButton
		navigationItem.rightBarButtonItem?.tintColor = .Pino.primary

		let profileButton = UIButton()
		profileButton.setImage(UIImage(named: "manage_asset"), for: .normal)
		profileButton.backgroundColor = .Pino.green1
		profileButton.pin(.fixedWidth(32), .fixedHeight(32))
		profileButton.layer.cornerRadius = 16
		navigationItem.leftBarButtonItem = UIBarButtonItem()
		navigationItem.leftBarButtonItem?.customView = profileButton
	}

	private func setupNavigationtitle() {
		let walletName = NSMutableAttributedString(string: "Amir", attributes: [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.label,
			NSAttributedString.Key.font: UIFont.PinoStyle.mediumCallout!])

		let walletAddress = NSMutableAttributedString(string: "(Gf4b...t2de)", attributes: [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel,
			NSAttributedString.Key.font: UIFont.PinoStyle.regularCallout!])

		walletName.append(walletAddress)

		let navigationBarTitle = UILabel()
		navigationBarTitle.attributedText = walletName
		navigationItem.titleView = navigationBarTitle
	}
}

//
//  IntroViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/7/22.
//

import UIKit

class IntroViewController: UIViewController {
	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
	}

	// MARK: Private Methods

	private func stupView() {
		let introContents = [
			IntroModel(
				image: UIImage(),
				title: "DeFi Hub",
				description: "Invest, borrow, and swap from top DeFi protocols smoothly."
			),
			IntroModel(
				image: UIImage(),
				title: "DeFi Hub",
				description: "Invest, borrow, and swap from top DeFi protocols smoothly."
			),
			IntroModel(
				image: UIImage(),
				title: "DeFi Hub",
				description: "Invest, borrow, and swap from top DeFi protocols smoothly."
			),
		]

		let introView = IntroView(content: introContents) {} importWallet: {}
		view = introView
	}
}

//
//  IntroViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/7/22.
//

import UIKit

class IntroViewController: UIViewController {
	// MARK: Private Properties

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
	}

	// MARK: Private Methods

	private func stupView() {
		let introView = IntroView {} importWallet: {}
		view = introView
	}
}

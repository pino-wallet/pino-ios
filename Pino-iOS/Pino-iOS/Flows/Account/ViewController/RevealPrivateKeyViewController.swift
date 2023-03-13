//
//  RevealPrivateKeyViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/13/23.
//

import UIKit

class RevealPrivateKeyViewController: UIViewController {
	// MARK: Private Properties

	private let revealPrivateKeyVM = RevealPrivateKeyViewModel()

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
		view = UIView()
	}

	private func setupNavigationBar() {
		// Setup title view
		setNavigationTitle("Your private key")
	}
}

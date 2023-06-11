//
//  EnterSendAmountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/10/23.
//

import UIKit

class EnterSendAmountViewController: UIViewController {
	// MARK: - Public Properties

	// MARK: Private Properties

	private let enterAmountVM = EnterSendamountViewModel()

	// MARK: Initializers

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillDisappear(_ animated: Bool) {
		// Save selected assets locally
	}

	// MARK: - Private Methods

	private func setupView() {
		view = EnterSendAmountView(
			enterAmountVM: enterAmountVM,
			changeSelectedToken: {},
			nextButtonTapped: {}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Enter amount")
	}
}

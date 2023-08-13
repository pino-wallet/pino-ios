//
//  InvestViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class InvestViewController: UIViewController {
	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		// It must be replaced with custom view
		view = InvestView()
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Invest")
	}
}

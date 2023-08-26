//
//  InvestConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import UIKit

class InvestConfirmationViewController: UIViewController {
	// MARK: - Private Properties

	private var confirmView: InvestConfirmationView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		confirmView = InvestConfirmationView(
			confirmButtonDidTap: {},
			infoActionSheetDidTap: { infoActionSheet in

			},
			feeCalculationRetry: {}
		)
		view = confirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Confirm investment")
	}
}

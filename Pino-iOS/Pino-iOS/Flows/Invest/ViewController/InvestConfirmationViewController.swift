//
//  InvestConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import UIKit

class InvestConfirmationViewController: UIViewController {
	// MARK: - Private Properties

	private let confirmationVM: InvestConfirmationViewModel

	// MARK: - Initializers

	init(confirmationVM: InvestConfirmationViewModel) {
		self.confirmationVM = confirmationVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

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
		view = InvestConfirmationView(
			investConfirmationVM: confirmationVM,
			confirmButtonDidTap: {},
			infoActionSheetDidTap: { infoActionSheet in

			},
			feeCalculationRetry: {}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Confirm investment")
	}
}

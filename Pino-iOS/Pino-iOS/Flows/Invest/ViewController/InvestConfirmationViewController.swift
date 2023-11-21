//
//  InvestConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import UIKit

class InvestConfirmationViewController: AuthenticationLockViewController {
	// MARK: - Private Properties

	private let investConfirmationVM: InvestConfirmationProtocol
	private var investConfirmationView: InvestConfirmationView!

	// MARK: - Initializers

	init(confirmationVM: InvestConfirmationProtocol) {
		self.investConfirmationVM = confirmationVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		investConfirmationVM.getTransactionInfo()
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
		investConfirmationView = InvestConfirmationView(
			investConfirmationVM: investConfirmationVM,
			confirmButtonDidTap: {
				self.confirmInvestment()
			},
			infoActionSheetDidTap: { infoActionSheet in
				self.showInfoActionSheet(infoActionSheet)
			},
			feeCalculationRetry: {
				self.getFee()
			}
		)

		view = investConfirmationView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Confirm investment")
	}

	private func showInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet) {
		present(feeInfoActionSheet, animated: true)
	}

	private func confirmInvestment() {
		unlockApp {
			self.investConfirmationVM.confirmTransaction {
				self.dismiss(animated: true)
			}
		}
	}

	private func getFee() {
		investConfirmationView.hideFeeCalculationError()
		investConfirmationView.showSkeletonView()
		investConfirmationVM.getTransactionInfo()
	}

	private func showFeeError(_ error: Error) {
		investConfirmationView.showfeeCalculationError()
		Toast.default(
			title: "\(error.localizedDescription)",
			subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			style: .error
		)
		.show(haptic: .warning)
	}
}

//
//  SendConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import UIKit

class SendConfirmationViewController: UIViewController {
	// MARK: Private Properties

	private let sendConfirmationVM: SendConfirmationViewModel
	private var sendConfirmationView: SendConfirmationView!
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

	// MARK: Initializers

	init(sendConfirmationVM: SendConfirmationViewModel) {
		self.sendConfirmationVM = sendConfirmationVM
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
		getFee()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		sendConfirmationView = SendConfirmationView(
			sendConfirmationVM: sendConfirmationVM,
			confirmButtonTapped: {
				self.confirmSend()
			},
			presentFeeInfo: { feeInfoActionSheet in
				self.showFeeInfoActionSheet(feeInfoActionSheet)
			},
			retryFeeCalculation: {
				self.getFee()
			}
		)
		view = sendConfirmationView
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Confirm transfer")
	}

	private func showFeeInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet) {
		present(feeInfoActionSheet, animated: true)
	}

	private func confirmSend() {
		authManager.unlockApp { [self] in
			guard let sendTransactions = sendConfirmationVM.sendTransactions else { return }
			sendConfirmationVM.setRecentAddress()
			let sendTransactionStatusVM = SendTransactionStatusViewModel(
				transactions: sendTransactions,
				transactionSentInfoText: sendConfirmationVM.sendStatusText
			)
			let sendTransactionStatusVC = SendTransactionStatusViewController(
				sendStatusVM: sendTransactionStatusVM,
				onDismiss: {}
			)
			present(sendTransactionStatusVC, animated: true)
		} onFailure: {
			#warning("Error should be handled")
		}
	}

	private func getFee() {
		sendConfirmationView.hideFeeCalculationError()
		sendConfirmationView.showSkeletonView()
		sendConfirmationVM.getFee { error in
			self.showFeeError(error)
		}
	}

	private func showFeeError(_ error: Error) {
		sendConfirmationView.showfeeCalculationError()
		Toast.default(
			title: "\(error.localizedDescription)",
			subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			style: .error
		)
		.show(haptic: .warning)
	}
}

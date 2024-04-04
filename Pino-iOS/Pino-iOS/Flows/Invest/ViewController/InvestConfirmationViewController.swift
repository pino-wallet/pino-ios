//
//  InvestConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import UIKit

class InvestConfirmationViewController: UIViewController {
	// MARK: - Private Properties

	private let investConfirmationVM: InvestConfirmationProtocol
	private var investConfirmationView: InvestConfirmationView!
	private var onConfirm: (SendTransactionStatus) -> Void
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

	// MARK: - Initializers

	init(confirmationVM: InvestConfirmationProtocol, onConfirm: @escaping (SendTransactionStatus) -> Void) {
		self.investConfirmationVM = confirmationVM
		self.onConfirm = onConfirm
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
			infoActionSheetDidTap: { infoActionSheet, completion in
				self.showInfoActionSheet(infoActionSheet, completion: completion)
			},
			feeCalculationRetry: {
				self.getFee()
			}
		)

		view = investConfirmationView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(investConfirmationVM.pageTitle)
	}

	private func showInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		present(feeInfoActionSheet, animated: true, completion: completion)
	}

	private func confirmInvestment() {
		authManager.unlockApp { [self] in
			guard let sendTransactions = investConfirmationVM.sendTransactions else { return }
			let investAmountBigNumber = BigNumber(numberWithDecimal: investConfirmationVM.transactionAmount)
			let sendTransactionStatusVM = SendTransactionStatusViewModel(
				transactions: sendTransactions,
				transactionSentInfoText: investConfirmationVM.transactionsDescription

			)
			let sendTransactionStatusVC = SendTransactionStatusViewController(
				sendStatusVM: sendTransactionStatusVM,
				onDismiss: onConfirm
			)
			present(sendTransactionStatusVC, animated: true)
		} onFailure: {
			#warning("Error should be handled")
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

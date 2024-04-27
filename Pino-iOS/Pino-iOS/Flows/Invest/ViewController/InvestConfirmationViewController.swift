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
	private let hapticManager = HapticManager()
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
		investConfirmationVM.getTransactionInfo().catch { error in
			self.showErrorToast()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			hapticManager.run(type: .lightImpact)
		}
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
		hapticManager.run(type: .selectionChanged)
		present(feeInfoActionSheet, animated: true, completion: completion)
	}

	private func confirmInvestment() {
		hapticManager.run(type: .mediumImpact)
		if UserDefaultsManager.securityModesUser.getValue()?
			.first(where: { $0 == SecurityOptionModel.LockType.on_transactions.rawValue }) != nil {
			authManager.unlockApp { [self] in
				self.sendTx()
			} onFailure: {
				#warning("maybe we should handle it later")
			}
		} else {
			sendTx()
		}
	}

	private func sendTx() {
		guard let sendTransactions = investConfirmationVM.sendTransactions else { return }
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: sendTransactions,
			transactionSentInfoText: investConfirmationVM.transactionsDescription
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(
			sendStatusVM: sendTransactionStatusVM,
			onDismiss: onConfirm
		)
		present(sendTransactionStatusVC, animated: true)
	}

	private func getFee() {
		hapticManager.run(type: .selectionChanged)
		investConfirmationView.hideFeeCalculationError()
		investConfirmationView.showSkeletonView()
		investConfirmationVM.getTransactionInfo().catch { error in
			self.showErrorToast()
		}
	}

	private func showErrorToast() {
		Toast.default(title: APIError.failedRequest.toastMessage, style: .error).show()
	}
}

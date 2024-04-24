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
	private let hapticManager = HapticManager()
	private var sendConfirmationView: SendConfirmationView!
	private var onSendConfirm: (SendTransactionStatus) -> Void
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

	// MARK: Initializers

	init(sendConfirmationVM: SendConfirmationViewModel, onSendConfirm: @escaping (SendTransactionStatus) -> Void) {
		self.sendConfirmationVM = sendConfirmationVM
		self.onSendConfirm = onSendConfirm
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
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		sendConfirmationVM.removeBindings()
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent, transitionCoordinator?.isInteractive == false {
            // code here
            hapticManager.run(type: .lightImpact)
        }
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
			presentFeeInfo: { feeInfoActionSheet, completion in
				self.showFeeInfoActionSheet(feeInfoActionSheet, completion: completion)
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

	private func showFeeInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		hapticManager.run(type: .selectionChanged)
		present(feeInfoActionSheet, animated: true, completion: completion)
	}

	private func confirmSend() {
		hapticManager.run(type: .mediumImpact)
		authManager.unlockApp { [self] in
			guard let sendTransactions = sendConfirmationVM.sendTransactions else { return }
			sendConfirmationVM.setRecentAddress()
			let sendTransactionStatusVM = SendTransactionStatusViewModel(
				transactions: sendTransactions,
				transactionSentInfoText: sendConfirmationVM.sendStatusText
			)
			let sendTransactionStatusVC = SendTransactionStatusViewController(
				sendStatusVM: sendTransactionStatusVM,
				onDismiss: { pageStatus in
					self.onSendConfirm(pageStatus)
				}
			)
			present(sendTransactionStatusVC, animated: true)
		} onFailure: {
			Toast.default(title: self.sendConfirmationVM.failedToAuth, style: .error).show()
		}
	}

	private func getFee() {
		sendConfirmationVM.getFee()
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}
}

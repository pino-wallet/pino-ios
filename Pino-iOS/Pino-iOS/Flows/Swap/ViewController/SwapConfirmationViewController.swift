//
//  SwapConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import Combine
import PromiseKit
import UIKit

class SwapConfirmationViewController: UIViewController {
	// MARK: Private Properties

	private let swapConfirmationVM: SwapConfirmationViewModel
	private var cancellables = Set<AnyCancellable>()
	private var swapConfirmationView: SwapConfirmationView!
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

	// MARK: Initializers

	init(swapConfirmationVM: SwapConfirmationViewModel) {
		self.swapConfirmationVM = swapConfirmationVM
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
		swapConfirmationVM.fetchSwapInfo { error in
			self.showFeeError(error)
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func getFee() {
		swapConfirmationView.hideFeeError()
		swapConfirmationView.showSkeletonView()
		swapConfirmationVM.fetchSwapInfo { error in
			self.showFeeError(error)
		}
	}

	private func setupView() {
		swapConfirmationView = SwapConfirmationView(
			swapConfirmationVM: swapConfirmationVM,
			confirmButtonTapped: {
				self.confirmSwap()
			},
			presentFeeInfo: { infoActionSheet in
				self.showFeeInfoActionSheet(infoActionSheet)
			},
			retryFeeCalculation: {
				self.getFee()
			}
		)
		view = swapConfirmationView
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Confirm swap")
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "dissmiss"),
			style: .plain,
			target: self,
			action: #selector(dismissPage)
		)
	}

	private func showFeeInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet) {
		present(feeInfoActionSheet, animated: true)
	}

	private func confirmSwap() {
		guard let sendTransactions = swapConfirmationVM.sendTransactions else { return }
		authManager.unlockApp { [self] in
			let sendTrxStatusVM = SendTransactionStatusViewModel(
				transactions: sendTransactions,
				transactionSentInfoText: swapConfirmationVM.sendStatusText
			)
			let sendTransactionStatuVC = SendTransactionStatusViewController(
				sendStatusVM: sendTrxStatusVM,
				onDismiss: dismissPage
			)
			present(sendTransactionStatuVC, animated: true)
		}
	}

	@objc
	private func dismissPage() {
		dismiss(animated: true)
	}

	private func showFeeError(_ error: Error) {
		swapConfirmationView.showfeeCalculationError()
		Toast.default(
			title: "\(error.localizedDescription)",
			subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			style: .error
		)
		.show(haptic: .warning)
	}
}

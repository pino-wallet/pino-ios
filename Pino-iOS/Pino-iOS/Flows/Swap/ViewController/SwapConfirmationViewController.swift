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
	private let hapticManager = HapticManager()
	private var cancellables = Set<AnyCancellable>()
	private var swapConfirmationView: SwapConfirmationView!
	private var onSwapConfirm: (SendTransactionStatus) -> Void
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

	// MARK: Initializers

	init(swapConfirmationVM: SwapConfirmationViewModel, onSwapConfirm: @escaping (SendTransactionStatus) -> Void) {
		self.swapConfirmationVM = swapConfirmationVM
		self.onSwapConfirm = onSwapConfirm
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
		swapConfirmationVM.fetchSwapInfo().catch { error in
			self.showFeeError(EtheriumNetworkError.estimationFailed)
		}

		if isBeingPresented || isMovingToParent {
			swapConfirmationView.swapConfirmationInfoView.showFeeLoading()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		swapConfirmationVM.destoryRateTimer()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func getFee() {
		hapticManager.run(type: .selectionChanged)
		swapConfirmationView.hideFeeError()
		swapConfirmationView.showSkeletonView()
		swapConfirmationVM.fetchSwapInfo().catch { error in
			self.showFeeError(EtheriumNetworkError.estimationFailed)
		}
	}

	private func setupView() {
		swapConfirmationView = SwapConfirmationView(
			swapConfirmationVM: swapConfirmationVM,
			confirmButtonTapped: {
				self.confirmSwap()
			},
			presentFeeInfo: { infoActionSheet, completion in
				self.showFeeInfoActionSheet(infoActionSheet, completion: completion)
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
			image: UIImage(named: "dismiss"),
			style: .plain,
			target: self,
			action: #selector(dismissPage)
		)
	}

	private func showFeeInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		hapticManager.run(type: .selectionChanged)
		present(feeInfoActionSheet, animated: true, completion: completion)
	}

	private func confirmSwap() {
		hapticManager.run(type: .mediumImpact)
        if UserDefaultsManager.securityModesUser.getValue()?.first(where: { $0 == SecurityOptionModel.LockType.on_transactions.rawValue }) != nil {
            authManager.unlockApp { [self] in
                self.sendTx()
            } onFailure: {
                Toast.default(title: self.swapConfirmationVM.failedToAuthTitle, style: .error).show()
            }
        } else {
            sendTx()
        }
	}
    
    private func sendTx() {
        guard let sendTransactions = swapConfirmationVM.sendTransactions else { return }
        let sendTrxStatusVM = SendTransactionStatusViewModel(
            transactions: sendTransactions,
            transactionSentInfoText: swapConfirmationVM.sendStatusText
        )
        let sendTransactionStatuVC = SendTransactionStatusViewController(
            sendStatusVM: sendTrxStatusVM,
            onDismiss: { [unowned self] pageStatus in
                onSwapConfirm(pageStatus)
            }
        )
        swapConfirmationVM.destoryRateTimer()
        present(sendTransactionStatuVC, animated: true)
    }

	@objc
	private func dismissPage() {
		hapticManager.run(type: .lightImpact)
		swapConfirmationVM.destoryRateTimer()
		dismiss(animated: true)
	}

	private func showFeeError(_ error: EtheriumNetworkError) {
		swapConfirmationView.showfeeCalculationError()
		Toast.default(title: error.toastMessage, style: .error).show(haptic: .warning)
	}
}

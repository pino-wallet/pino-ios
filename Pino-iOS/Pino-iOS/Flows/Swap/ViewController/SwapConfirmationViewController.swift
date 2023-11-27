//
//  SwapConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import Combine
import PromiseKit
import UIKit

class SwapConfirmationViewController: AuthenticationLockViewController {
	// MARK: Private Properties

	private let swapConfirmationVM: SwapConfirmationViewModel
	private var cancellables = Set<AnyCancellable>()
	private var swapConfirmationView: SwapConfirmationView!

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
			presentFeeInfo: { infoActionSheet in },
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
		swapConfirmationVM.confirmSwap {
			self.dismissPage()
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

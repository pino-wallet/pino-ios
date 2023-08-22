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
        
        let ap = ApproveContractViewModel()
        ap.approveProvider()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = SwapConfirmationView(
			swapConfirmationVM: swapConfirmationVM,
			confirmButtonTapped: {
				self.confirmSwap()
			},
			presentFeeInfo: { infoActionSheet in },
			retryFeeCalculation: {}
		)
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
		let web3 = Web3Core.shared
		let trxAmount = 234_567
		// Added temporarily for test and next part of task
		firstly {
			try web3.getAllowanceOf(
				contractAddress: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
				spenderAddress: "0x000000000022D473030F116dDEE9F6B43aC78BA3",
				ownerAddress: "0x56789"
			)
		}.done { allowanceAmount in
			if allowanceAmount == 0 || allowanceAmount < trxAmount {
				// NOT ALLOWED -> SHOW APPROVE PAGE

			} else {
				// ALLOWED -> SHOW CONFIRM PAGE
			}
		}.catch { error in
			print(error)
		}
        

		unlockApp {}
	}

	@objc
	private func dismissPage() {
		dismiss(animated: true)
	}
}

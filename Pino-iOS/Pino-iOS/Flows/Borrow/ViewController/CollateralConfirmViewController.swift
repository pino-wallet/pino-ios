//
//  CollateralConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit
import Web3

class CollateralConfirmViewController: UIViewController {
	// MARK: - TypeAliases

	typealias onDismissClosureType = (SendTransactionStatus) -> Void

	// MARK: - Closures

	private let onDismiss: onDismissClosureType

	// MARK: - Private Properties

	private let collateralConfirmVM: CollateralConfirmViewModel
	private var collateralConfirmView: CollateralConfirmView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			collateralConfirmView.showSkeletonView()
			collateralConfirmVM.getCollateralGasInfo()
		}
	}

	// MARK: - Initializers

	init(collateralConfirmVM: CollateralConfirmViewModel, onDismiss: @escaping onDismissClosureType) {
		self.collateralConfirmVM = collateralConfirmVM
		self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		collateralConfirmView = CollateralConfirmView(
			collateralConfrimVM: collateralConfirmVM,
			presentActionSheetClosure: { actionSheet, completion in
				self.presentActionSheet(actionSheet: actionSheet, completion: completion)
			}
		)

		collateralConfirmVM.confirmCollateralClosure = { depositTRXList in
			self.confirmCollateral(depositTRXList: depositTRXList)
		}

		view = collateralConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(collateralConfirmVM.pageTitle)
	}

	private func confirmCollateral(depositTRXList: [SendTransactionViewModel]) {
		let collateralIncreaseAmountVM = collateralConfirmVM.collaterallIncreaseAmountVM
		let collateralAmountBigNumber = BigNumber(numberWithDecimal: collateralIncreaseAmountVM.tokenAmount)
		let sendTransactionStatusVM = SendTransactionStatusViewModel(
			transactions: depositTRXList,
			transactionSentInfoText: "You collateralized \(collateralAmountBigNumber!.sevenDigitFormat) \(collateralIncreaseAmountVM.selectedToken.symbol) in \(collateralIncreaseAmountVM.borrowVM.selectedDexSystem.name) \(collateralIncreaseAmountVM.borrowVM.selectedDexSystem.version)."
		)
		let sendTransactionStatusVC = SendTransactionStatusViewController(
			sendStatusVM: sendTransactionStatusVM,
			onDismiss: { pageStatus in
				self.onDismiss(pageStatus)
			}
		)
		present(sendTransactionStatusVC, animated: true)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet, completion: @escaping () -> Void) {
		present(actionSheet, animated: true, completion: completion)
	}
}

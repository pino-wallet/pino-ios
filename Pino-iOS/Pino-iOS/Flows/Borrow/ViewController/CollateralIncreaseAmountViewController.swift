//
//  CollateralIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import PromiseKit
import UIKit

class CollateralIncreaseAmountViewController: UIViewController {
	// MARK: - TypeAliases

	typealias onDismissClosureType = (SendTransactionStatus) -> Void

	// MARK: - Closures

	private let onDismiss: onDismissClosureType

	// MARK: - Private Properties

	private let collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel
	private let web3 = Web3Core.shared
	private let checkForAllowanceErrorText = "Failed to check for allowance of token"
	private var collateralIncreaseAmountView: CollateralIncreaseAmountView!

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
			collateralIncreaseAmountVM.setupRequestTimer()
			collateralIncreaseAmountView.showSkeletonView()
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		collateralIncreaseAmountVM.destroyRequestTimer()
	}

	// MARK: Initializers

	init(collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel, onDismiss: @escaping onDismissClosureType) {
		self.collateralIncreaseAmountVM = collateralIncreaseAmountVM
		self.onDismiss = onDismiss

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		collateralIncreaseAmountView = CollateralIncreaseAmountView(
			collateralIncreaseAmountVM: collateralIncreaseAmountVM,
			nextButtonTapped: {
				self.checkForAllowance()
			}
		)

		view = collateralIncreaseAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle(
			"\(collateralIncreaseAmountVM.pageTitleCollateralText) \(collateralIncreaseAmountVM.tokenSymbol)"
		)
	}

	private func checkForAllowance() {
		// Check If Permit has access to Token
		collateralIncreaseAmountVM.checkTokenAllowance().done { didUserHasAllowance, tokenId in
			if didUserHasAllowance {
				self.pushToCollateralConfirmVC()
			} else {
				self.presentApproveVC(tokenContractAddress: tokenId)
			}
		}.catch { error in
			Toast.default(
				title: self.checkForAllowanceErrorText,
				subtitle: GlobalToastTitles.tryAgainToastTitle.message,
				style: .error
			)
			.show(haptic: .warning)
		}
	}

	private func presentApproveVC(tokenContractAddress: String) {
		let approveVC = ApproveContractViewController(
			approveContractID: tokenContractAddress,
			showConfirmVC: {
				self.pushToCollateralConfirmVC()
			}, approveType: .collateral
		)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [approveVC]
		present(navigationVC, animated: true)
	}

	private func pushToCollateralConfirmVC() {
		let collateralConfirmVM = CollateralConfirmViewModel(collaterallIncreaseAmountVM: collateralIncreaseAmountVM)
		let collateralConfirmVC = CollateralConfirmViewController(
			collateralConfirmVM: collateralConfirmVM,
			onDismiss: { pageStatus in
				self.onDismiss(pageStatus)
			}
		)
		navigationController?.pushViewController(collateralConfirmVC, animated: true)
	}
}

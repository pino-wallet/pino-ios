//
//  CollateralIncreaseAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import PromiseKit
import UIKit
import Web3_Utility

class CollateralIncreaseAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel
	private let web3 = Web3Core.shared
	private let walletManager = PinoWalletManager()
	private var collateralIncreaseAmountView: CollateralIncreaseAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: Initializers

	init(collateralIncreaseAmountVM: CollateralIncreaseAmountViewModel) {
		self.collateralIncreaseAmountVM = collateralIncreaseAmountVM

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
		if collateralIncreaseAmountVM.selectedToken.isEth {
			pushToCollateralConfirmVC()
			return
		}
		firstly {
			try web3.getAllowanceOf(
				contractAddress: collateralIncreaseAmountVM.selectedToken.id.lowercased(),
				spenderAddress: Web3Core.Constants.permitAddress,
				ownerAddress: walletManager.currentAccount.eip55Address
			)
		}.done { [self] allowanceAmount in
			let destTokenDecimal = collateralIncreaseAmountVM.selectedToken.decimal
			let destTokenAmount = Utilities.parseToBigUInt(
				collateralIncreaseAmountVM.tokenAmount,
				decimals: destTokenDecimal
			)
			if allowanceAmount == 0 || allowanceAmount < destTokenAmount! {
				// NOT ALLOWED
				presentApproveVC()
			} else {
				// ALLOWED
				pushToCollateralConfirmVC()
			}
		}.catch { error in
			print(error)
		}
	}

	private func presentApproveVC() {
		let approveVC = ApproveContractViewController(
			approveContractID: collateralIncreaseAmountVM.selectedToken.id,
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
		let collateralConfirmVC = CollateralConfirmViewController(collateralConfirmVM: collateralConfirmVM)
		navigationController?.pushViewController(collateralConfirmVC, animated: true)
	}
}

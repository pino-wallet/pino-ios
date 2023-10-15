//
//  RepayAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import PromiseKit
import UIKit
import Web3_Utility

class RepayAmountViewController: UIViewController {
	// MARK: - Private Properties

	private let walletManager = PinoWalletManager()
	private let web3 = Web3Core.shared
	private var repayAmountVM: RepayAmountViewModel
	private var repayAmountView: RepayAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Initializers

	init(repayAmountVM: RepayAmountViewModel) {
		self.repayAmountVM = repayAmountVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		repayAmountView = RepayAmountView(repayAmountVM: repayAmountVM, nextButtonTapped: {
			self.checkForAllowance()
		})

		view = repayAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle("\(repayAmountVM.pageTitleRepayText) \(repayAmountVM.tokenSymbol)")
	}

	private func checkForAllowance() {
		// Check If Permit has access to Token
		if repayAmountVM.selectedToken.isEth {
			pushToRepayConfirmVC()
			return
		}
		firstly {
			try web3.getAllowanceOf(
				contractAddress: repayAmountVM.selectedToken.id.lowercased(),
				spenderAddress: Web3Core.Constants.permitAddress,
				ownerAddress: walletManager.currentAccount.eip55Address
			)
		}.done { [self] allowanceAmount in
			let destTokenDecimal = repayAmountVM.selectedToken.decimal
			let destTokenAmount = Utilities.parseToBigUInt(
				repayAmountVM.tokenAmount,
				decimals: destTokenDecimal
			)
			if allowanceAmount == 0 || allowanceAmount < destTokenAmount! {
				// NOT ALLOWED
				presentApproveVC()
			} else {
				// ALLOWED
				pushToRepayConfirmVC()
			}
		}.catch { error in
			print(error)
		}
	}

	private func presentApproveVC() {
		let approveVC = ApproveContractViewController(
			approveContractID: repayAmountVM.selectedToken.id,
			showConfirmVC: {
				self.pushToRepayConfirmVC()
            }, approveType: .repay
		)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [approveVC]
		present(navigationVC, animated: true)
	}

	private func pushToRepayConfirmVC() {
		let repayConfirmVM = RepayConfirmViewModel(repayamountVM: repayAmountVM)
		let repayConfirmVC = RepayConfirmViewController(repayConfirmVM: repayConfirmVM)
		navigationController?.pushViewController(repayConfirmVC, animated: true)
	}
}

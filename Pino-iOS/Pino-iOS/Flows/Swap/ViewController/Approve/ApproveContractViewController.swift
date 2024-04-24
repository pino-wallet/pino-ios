//
//  ApproveContractViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Foundation
import UIKit

class ApproveContractViewController: UIViewController {
	// MARK: - Closures

	private var showConfirmVC: () -> Void

	// MARK: - Private Properties

	private let approveContractVM: ApproveContractViewModel!
	private let hapticManager = HapticManager()
	private var approveContractView: ApproveContractView!
	private var approveContractID: String!
	private var approveType: ApproveType

	// MARK: - Public Properties

	public enum ApproveType: String {
		case collateral = "collateralizing"
		case invest = "investing"
		case withdraw = "Withdrawal"
		case swap = "swapping"
		case repay = "repayment"
	}

	// MARK: - Initilizers

	init(approveContractID: String, showConfirmVC: @escaping () -> Void, approveType: ApproveType) {
		self.approveContractID = approveContractID
		self.approveContractVM = ApproveContractViewModel(contractId: approveContractID)
		self.showConfirmVC = showConfirmVC
		self.approveType = approveType
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: approveContractVM.dismissButtonName),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
		setNavigationTitle(approveContractVM.pageTitle)
	}

	private func setupView() {
		approveContractView = ApproveContractView(approveContractVM: approveContractVM, onApproveTap: {
			self.showApproveLoadingPage()
		}, approveType: approveType)

		view = approveContractView
	}

	private func showApproveLoadingPage() {
		hapticManager.run(type: .mediumImpact)
		approveContractVM.goToApproveLoading { approveContractDetails in
			let approveLoadingVM = ApprovingLoadingViewModel(
				approveContractDetails: approveContractDetails,
				approveContractVM: self.approveContractVM
			)
			let approveLoadingVC = ApprovingLoadingViewController(
				showConfirmVC: {
					self.dismiss(animated: true) {
						self.showConfirmVC()
					}
				}, approveLoadingVM: approveLoadingVM, onDismiss: {
					self.calculateApproveFee()
				}
			)
			self.present(approveLoadingVC, animated: true)
		}
	}

	private func calculateApproveFee() {
		approveContractVM.getApproveDetails()
	}

	@objc
	private func dismissSelf() {
		hapticManager.run(type: .lightImpact)
		dismiss(animated: true)
	}
}

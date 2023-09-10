//
//  ApproveContractViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Foundation
import UIKit

class ApproveContractViewController: UIViewController {
	// MARK: - Private Properties

	private let approveContractVM: ApproveContractViewModel!
	private var approveContractView: ApproveContractView!
	private var swapConfirmationVM: SwapConfirmationViewModel!

	// MARK: - Initilizers

	init(swapConfirmationVM: SwapConfirmationViewModel) {
		self.swapConfirmationVM = swapConfirmationVM
		self.approveContractVM = ApproveContractViewModel(swapConfirmVM: swapConfirmationVM)
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

	override func viewWillAppear(_ animated: Bool) {}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Approve")
	}

	private func setupView() {
		approveContractView = ApproveContractView(approveContractVM: approveContractVM, onApproveTap: {
			self.showApproveLoadingPage()
		})

		view = approveContractView
	}

	private func showApproveLoadingPage() {
		let approveLoadingVC = ApprovingLoadingViewController(swapConfirmationVM: swapConfirmationVM)
		present(approveLoadingVC, animated: true)
	}
}

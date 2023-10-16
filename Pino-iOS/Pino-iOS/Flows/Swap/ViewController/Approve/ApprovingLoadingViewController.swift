//
//  ApprovingLoadingViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/24/23.
//

import Combine
import UIKit

class ApprovingLoadingViewController: UIViewController {
	// MARK: - Closures

	private var showConfirmVC: () -> Void
	private var onDismiss: () -> Void

	// MARK: - Private Properties

	private let approveLoadingVM: ApprovingLoadingViewModel
	private var approveLoadingView: ApprovingLoadingView!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initilizers

	init(
		showConfirmVC: @escaping () -> Void,
		approveLoadingVM: ApprovingLoadingViewModel,
		onDismiss: @escaping () -> Void
	) {
		self.showConfirmVC = showConfirmVC
		self.approveLoadingVM = approveLoadingVM
		self.onDismiss = onDismiss
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
		setupBindings()
	}

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			approveLoadingVM.getApproveTransactionFormVC()
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		approveLoadingVM.destroyTimer()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
	}

	private func setupView() {
		approveLoadingView = ApprovingLoadingView(approvingLoadingVM: approveLoadingVM, dismissPage: {
			self.dismiss(animated: true)
			self.onDismiss()
		})
		view = approveLoadingView
	}

	private func openConfirmationPage() {
		dismiss(animated: true) {
			self.showConfirmVC()
		}
	}

	private func setupBindings() {
		approveLoadingVM.$approveLoadingStatus.sink { approveLoadingStatus in
			self.updateModalInPresentationWithLoadingStatus(status: approveLoadingStatus)
			if approveLoadingStatus == .done {
				self.openConfirmationPage()
			}
		}.store(in: &cancellables)
	}

	private func updateModalInPresentationWithLoadingStatus(status: ApprovingLoadingViewModel.ApproveLoadingStatuses) {
		switch status {
		case .normalLoading:
			isModalInPresentation = true
		case .showSpeedUp:
			isModalInPresentation = false
		case .fastLoading:
			isModalInPresentation = true
		case .error:
			isModalInPresentation = false
		case .done:
			return
		}
	}
}

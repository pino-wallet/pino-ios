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

	// MARK: - Private Properties

	private let approveLoadingVM: ApprovingLoadingViewModel
	private var approveLoadingView: ApprovingLoadingView!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initilizers

	init(showConfirmVC: @escaping () -> Void, approveLoadingVM: ApprovingLoadingViewModel) {
		self.showConfirmVC = showConfirmVC
		self.approveLoadingVM = approveLoadingVM
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

	override func viewWillAppear(_ animated: Bool) {}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
	}

	private func setupView() {
		approveLoadingView = ApprovingLoadingView(approvingLoadingVM: approveLoadingVM)
		view = approveLoadingView
	}

	private func openConfirmationPage() {
		dismiss(animated: true)
		showConfirmVC()
	}

	private func setupBindings() {
		approveLoadingVM.$isApproved.sink { isApproved in
			if isApproved {
				self.openConfirmationPage()
			}
		}.store(in: &cancellables)
	}
}

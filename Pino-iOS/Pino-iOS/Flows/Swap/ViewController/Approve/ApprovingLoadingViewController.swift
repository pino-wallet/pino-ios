//
//  ApprovingLoadingViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/24/23.
//

import UIKit

class ApprovingLoadingViewController: UIViewController {
	// MARK: - Closures

	private var showConfirmVC: () -> Void

	// MARK: - Private Properties

	private let approveLoadingVM = ApprovingLoadingViewModel()
	private var approveLoadingView: ApprovingLoadingView!

	// MARK: - Initilizers

	init(showConfirmVC: @escaping () -> Void) {
		self.showConfirmVC = showConfirmVC
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		#warning("Fill when approve is done")
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.openConfirmationPage()
		}
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	override func viewWillAppear(_ animated: Bool) {}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
	}

	private func setupView() {
		isModalInPresentation = true
		approveLoadingView = ApprovingLoadingView(approvingLoadingVM: approveLoadingVM)
		view = approveLoadingView
	}

	private func openConfirmationPage() {
		dismiss(animated: true)
		showConfirmVC()
	}
}

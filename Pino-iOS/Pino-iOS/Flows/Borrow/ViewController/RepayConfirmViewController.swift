//
//  RepayConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit

class RepayConfirmViewController: UIViewController {
	// MARK: - Private Properties

	private let repayConfirmVM: RepayConfirmViewModel
	private var repayConfirmView: RepayConfirmView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Initializers

	init(repayConfirmVM: RepayConfirmViewModel) {
		self.repayConfirmVM = repayConfirmVM

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		repayConfirmView = RepayConfirmView(repayConfrimVM: repayConfirmVM, presentActionSheetClosure: { actionSheet in
			self.presentActionSheet(actionSheet: actionSheet)
		})

		view = repayConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(repayConfirmVM.pageTitle)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}
}

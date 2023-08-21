//
//  LoanDetailsViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import UIKit

class LoanDetailsViewController: UIViewController {
	// MARK: - Private Properties

	private let loanDetailsVM = LoanDetailsViewModel()
	private var loanDetailsView: LoanDetailsView!

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
		setNavigationTitle(loanDetailsVM.pageTitle)
	}

	private func setupView() {
		loanDetailsView = LoanDetailsView(loanDetailsVM: loanDetailsVM)

		view = loanDetailsView
	}
}

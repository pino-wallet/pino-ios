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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: loanDetailsVM.dismissIconName), style: .plain, target: self, action: #selector(dismissSelf))
	}

	private func setupView() {
		loanDetailsView = LoanDetailsView(loanDetailsVM: loanDetailsVM)

		view = loanDetailsView
	}
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

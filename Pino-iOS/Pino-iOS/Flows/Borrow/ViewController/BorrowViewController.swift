//
//  BorrowViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class BorrowViewController: UIViewController {
	// MARK: - Private Properties

	private let borrowVM = BorrowViewModel()
	private var borrowView: BorrowView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	override func viewWillAppear(_ animated: Bool) {
		if isBeingPresented || isMovingToParent {
			borrowVM.getBorrowingDetailsFromVC()
		}
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowVM.pageTitle)
	}

	private func setupView() {
		borrowView = BorrowView(borrowVM: borrowVM, presentActionsheet: { actionSheet in
			self.present(actionSheet, animated: true)
		})

		view = borrowView
	}
}

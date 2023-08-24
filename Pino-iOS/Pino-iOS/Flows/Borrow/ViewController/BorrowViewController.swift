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
		borrowVM.getBorrowingDetailsFromVC()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowVM.pageTitle)
	}

	private func setupView() {
		borrowView = BorrowView(borrowVM: borrowVM, presentHealthScoreActionsheet: { actionSheet in
			self.present(actionSheet, animated: true)
		}, presentSelectDexSystem: {
			self.presentSelectDexSystemVC()
		})

		view = borrowView
	}

	private func presentSelectDexSystemVC() {
		let selectDexSystemVC = BorrowSelectDexViewController(dexSystemDidSelectClosure: { selectedDexSystem in
			self.borrowVM.changeSelectedDexSystem(newSelectedDexSystem: selectedDexSystem)
		})
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [selectDexSystemVC]

		present(navigationVC, animated: true)
	}
}

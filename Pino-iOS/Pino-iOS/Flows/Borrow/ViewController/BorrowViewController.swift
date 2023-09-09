//
//  BorrowViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//
import Combine
import UIKit

class BorrowViewController: UIViewController {
	// MARK: - Private Properties

	private let borrowVM = BorrowViewModel()
	private var borrowView: BorrowView!
	private var cancellable = Set<AnyCancellable>()

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
		if borrowVM.userBorrowingDetails == nil {
			borrowView.showLoading()
		}
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
		}, presentBorrowingBoardVC: {
			self.presentBorrowingBoard()
		}, presentCollateralizingBoardVC: {
			self.presentCollateralizingBoard()
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

	private func presentBorrowingBoard() {
		let borrowingBoardVC = BorrowingBoardViewController(borrowVM: borrowVM)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [borrowingBoardVC]
		present(navigationVC, animated: true)
	}

	private func presentCollateralizingBoard() {
		let collateralizingBoardVC = CollateralizingBoardViewController(borrowVM: borrowVM)
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [collateralizingBoardVC]
		present(navigationVC, animated: true)
	}
}

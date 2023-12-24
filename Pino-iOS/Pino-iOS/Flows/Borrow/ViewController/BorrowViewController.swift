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
    private var healthScoreSystemVC: HealthScoreSystemViewController!
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
		if borrowVM.userBorrowingDetails == nil {
			borrowView.showLoading()
		}
		showTutorial()
	}

	override func viewDidDisappear(_ animated: Bool) {
		borrowVM.destroyRequestTimer()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowVM.pageTitle)
	}

	private func setupView() {
		borrowView = BorrowView(borrowVM: borrowVM, presentHealthScoreActionsheet: { healthScoreSystemVM in
			self.presentHealthScoreView(healthScoreSystemVM: healthScoreSystemVM)
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

	private func presentHealthScoreView(healthScoreSystemVM: HealthScoreSystemViewModel) {
        healthScoreSystemVC = HealthScoreSystemViewController(healthScoreSystemInfoVM: healthScoreSystemVM)
        		present(healthScoreSystemVC, animated: true, completion: {
                    let disMissTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissHealthScore))
                    self.healthScoreSystemVC.view.superview?.subviews[0].addGestureRecognizer(disMissTapGesture)
                    self.healthScoreSystemVC.view.superview?.subviews[0].isUserInteractionEnabled = true
        })
	}

	private func showTutorial() {
		if !UserDefaults.standard.bool(forKey: "hasSeenBorrowTut") {
			let tutorialPage = TutorialViewController(tutorialType: .borrow) {
				self.dismiss(animated: true)
			}
			tutorialPage.modalPresentationStyle = .overFullScreen
			present(tutorialPage, animated: true)
		}
	}
    @objc private func dismissHealthScore() {
        healthScoreSystemVC.dismiss(animated: true)
    }
}

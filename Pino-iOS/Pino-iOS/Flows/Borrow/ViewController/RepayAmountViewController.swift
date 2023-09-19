//
//  RepayAmountViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import UIKit

class RepayAmountViewController: UIViewController {
	// MARK: - Private Properties

    private var repayAmountVM: RepayAmountViewModel
	private var repayAmountView: RepayAmountView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}
    
    // MARK: - Initializers
    init(repayAmountVM: RepayAmountViewModel) {
        self.repayAmountVM = repayAmountVM
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	// MARK: - Private Methods

	private func setupView() {
		#warning("this should be changed")
		repayAmountView = RepayAmountView(repayAmountVM: repayAmountVM, nextButtonTapped: {
			self.pushToRepayConfirmVC()
		})

		view = repayAmountView
	}

	private func setupNavigationBar() {
		setNavigationTitle("\(repayAmountVM.pageTitleRepayText) \(repayAmountVM.tokenSymbol)")
	}

	#warning("this should be changed")
	private func pushToRepayConfirmVC() {
		let repayConfirmVC = RepayConfirmViewController()
		navigationController?.pushViewController(repayConfirmVC, animated: true)
	}
}

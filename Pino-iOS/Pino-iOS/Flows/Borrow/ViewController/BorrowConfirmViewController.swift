//
//  BorrowConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import UIKit

class BorrowConfirmViewController: UIViewController {
	// MARK: - Private Properties

    private let borrowConfirmVM: BorrowConfirmViewModel
	private var borrowConfirmView: BorrowConfirmView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}
    
    // MARK: - Initializers
    init(borrowConfirmVM: BorrowConfirmViewModel) {
        self.borrowConfirmVM = borrowConfirmVM
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	// MARK: - Private Methods

	private func setupView() {
		borrowConfirmView = BorrowConfirmView(
			borrowConfirmVM: borrowConfirmVM,
			presentActionSheetClosure: { actionSheet in
				self.presentActionSheet(actionSheet: actionSheet)
			}
		)

		view = borrowConfirmView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(borrowConfirmVM.pageTitle)
	}

	private func presentActionSheet(actionSheet: InfoActionSheet) {
		present(actionSheet, animated: true)
	}
}

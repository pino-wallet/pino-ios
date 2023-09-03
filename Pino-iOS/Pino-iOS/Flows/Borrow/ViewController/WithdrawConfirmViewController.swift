//
//  WithdrawViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit

class WithdrawConfirmViewController: UIViewController {
    // MARK: - Private Properties

    private let withdrawConfirmVM = WithdrawConfirmViewModel()
    private var withdrawConfirmView: WithdrawConfirmView!

    // MARK: - View Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        setupView()
        setupNavigationBar()
    }

    // MARK: - Private Methods

    private func setupView() {
        withdrawConfirmView = WithdrawConfirmView(withdrawConfrimVM: withdrawConfirmVM, presentActionSheetClosure: { actionSheet in
            self.presentActionSheet(actionSheet: actionSheet)
        })

        view = withdrawConfirmView
    }

    private func setupNavigationBar() {
        setupPrimaryColorNavigationBar()
        setNavigationTitle(withdrawConfirmVM.pageTitle)
    }

    private func presentActionSheet(actionSheet: InfoActionSheet) {
        present(actionSheet, animated: true)
    }
}

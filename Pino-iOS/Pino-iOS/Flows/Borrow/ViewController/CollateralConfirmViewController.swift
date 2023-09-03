//
//  CollateralConfirmViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit

class CollateralConfirmViewController: UIViewController {
    // MARK: - Private Properties

    private let collateralConfirmVM = CollateralConfirmViewModel()
    private var collateralConfirmView: CollateralConfirmView!

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
        collateralConfirmView = CollateralConfirmView(collateralConfrimVM: collateralConfirmVM, presentActionSheetClosure: { actionSheet in
            self.presentActionSheet(actionSheet: actionSheet)
        })

        view = collateralConfirmView
    }

    private func setupNavigationBar() {
        setupPrimaryColorNavigationBar()
        setNavigationTitle(collateralConfirmVM.pageTitle)
    }

    private func presentActionSheet(actionSheet: InfoActionSheet) {
        present(actionSheet, animated: true)
    }
}

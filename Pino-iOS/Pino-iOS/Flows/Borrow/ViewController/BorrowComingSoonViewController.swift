//
//  BorrowCommingSoonViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/24.
//

import UIKit

class BorrowComingSoonViewController: UIViewController {
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
		setNavigationTitle("Borrow")
	}

	private func setupView() {
		view = BorrowComingSoonView()
	}
}

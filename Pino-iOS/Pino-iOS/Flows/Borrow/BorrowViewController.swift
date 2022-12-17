//
//  BorrowViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class BorrowViewController: UIViewController {
	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
	}

	// MARK: - Private Methods

	private func stupView() {
		// It have to be replaced with custom view
		view = UIView()
		view.backgroundColor = .Pino.background
	}
}

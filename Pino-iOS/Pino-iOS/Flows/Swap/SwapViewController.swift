//
//  SwapViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class SwapViewController: UIViewController {
	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		// It must be replaced with custom view
		view = UIView()
		view.backgroundColor = .Pino.background
	}
}

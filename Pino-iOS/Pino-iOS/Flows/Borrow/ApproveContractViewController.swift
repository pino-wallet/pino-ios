//
//  ApproveContractViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Foundation
import UIKit

class ApproveContractViewController: UIViewController {
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

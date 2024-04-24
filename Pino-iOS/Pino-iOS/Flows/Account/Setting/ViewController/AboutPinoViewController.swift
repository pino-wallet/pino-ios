//
//  AboutPinoViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

import UIKit

class AboutPinoViewController: UIViewController {
	// MARK: Private Properties

	private let aboutPinoVM = AboutPinoViewModel()

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			HapticManager().run(type: .lightImpact)
		}
	}

	// MARK: Private Methods

	private func setupView() {
		view = AboutPinoView(aboutPinoVM: aboutPinoVM)
	}

	private func setupNavigationBar() {
		setNavigationTitle("About Pino")
	}
}

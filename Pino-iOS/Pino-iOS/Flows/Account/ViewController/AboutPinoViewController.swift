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

	// MARK: Private Methods

	private func setupView() {
		let aboutPinoView = AboutPinoView(aboutPinoVM: aboutPinoVM) {}
		view = aboutPinoView
	}

	private func setupNavigationBar() {
		setNavigationTitle("About Pino")
	}
}

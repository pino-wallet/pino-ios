//
//  ImportWalletViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/22/22.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView()
		setNavigationBackButton()
	}

	// MARK: Private Methods

	private func stupView() {
		view = UIView()
	}

	private func setSteperView() {
		// show steper view in navigation bar
		let stepperView = PinoStepperView(stepsCount: 2, currentStep: 1)
		navigationItem.titleView = stepperView
		navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
	}

	private func setNavigationBackButton() {
		let backImage = UIImage(systemName: "arrow.left")
		let backButton = UIBarButtonItem(
			image: backImage,
			style: .plain,
			target: self,
			action: #selector(backToPreviousPage)
		)
		backButton.tintColor = .Pino.label
		navigationItem.setLeftBarButton(backButton, animated: true)
	}

	@objc
	private func backToPreviousPage() {
		navigationController?.popViewController(animated: true)
	}
}

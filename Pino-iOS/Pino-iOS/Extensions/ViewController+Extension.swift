//
//  Navigation+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/25/22.
//

import UIKit

extension UIViewController {
	// MARK: Public Methods

	public func setSteperView(stepsCount: Int, curreuntStep: Int) {
		// Show steper view in the navigation bar
		let stepperView = PinoStepperView(stepsCount: stepsCount, currentStep: curreuntStep)
		navigationItem.titleView = stepperView
		setupNavigationBarStyle()
	}

	public func setupNavigationBackButton() {
		// Show custom back button in the navigation bar
		let backImage = UIImage(systemName: "arrow.left")
		let backButton = UIBarButtonItem(
			image: backImage,
			style: .plain,
			target: self,
			action: #selector(backToPreviousViewController)
		)
		backButton.tintColor = .Pino.label
		navigationItem.setLeftBarButton(backButton, animated: true)
		setupNavigationBarStyle()
	}

	public func removeNavigationBackButton() {
		// Lock back button in the navigation bar
		let backButton = UIBarButtonItem(
			image: nil,
			style: .plain,
			target: self,
			action: nil
		)
		navigationItem.setLeftBarButton(backButton, animated: false)
	}

	// MARK: Private Methods

	private func setupNavigationBarStyle() {
		navigationController?.navigationBar.backgroundColor = .Pino.clear
		navigationController?.navigationBar.shadowImage = UIImage()
	}

	@objc
	private func backToPreviousViewController() {
		navigationController?.popViewController(animated: true)
	}
}

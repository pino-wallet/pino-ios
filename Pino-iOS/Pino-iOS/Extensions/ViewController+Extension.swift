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
}

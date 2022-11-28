//
//  AlertHelper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/27/22.
//

import Foundation
import UIKit

class AlertHelper {
	static func showAlert(title: String?, message: String?, over viewController: UIViewController) {
		assert((title ?? message) != nil, "Title OR message must be passed in")

		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(.gotIt)
		viewController.present(alertController, animated: true)
	}
}

extension UIAlertAction {
	static var gotIt: UIAlertAction {
		UIAlertAction(title: "Got it", style: .default, handler: nil)
	}
}

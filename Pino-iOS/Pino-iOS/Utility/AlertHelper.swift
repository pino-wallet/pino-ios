//
//  AlertHelper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/27/22.
//

import Foundation
import UIKit

class AlertHelper {
	static func alertController(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
		assert((title ?? message) != nil, "Title OR message must be passed in")

		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		for action in actions {
			alertController.addAction(action)
		}
		return alertController
	}
}

extension UIAlertAction {
	static var gotIt: UIAlertAction {
		UIAlertAction(title: "Got it", style: .default, handler: nil)
	}

	static var ok: UIAlertAction {
		UIAlertAction(title: "OK", style: .default, handler: nil)
	}

	static var cancel: UIAlertAction {
		UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
	}

	static var delete: UIAlertAction {
		UIAlertAction(title: "Delete", style: .destructive, handler: nil)
	}

	static var allow: UIAlertAction {
		UIAlertAction(title: "Allow", style: .default, handler: nil)
	}

	static var dontAllow: UIAlertAction {
		UIAlertAction(title: "Don't Allow", style: .cancel, handler: nil)
	}

	static var yes: UIAlertAction {
		UIAlertAction(title: "Yes", style: .default, handler: nil)
	}

	static var no: UIAlertAction {
		UIAlertAction(title: "No", style: .default, handler: nil)
	}
}

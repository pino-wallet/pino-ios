//
//  AlertHelper.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/27/22.
//
// swiftlint: disable identifier_name

import Foundation
import UIKit

class AlertHelper {
	static func alertController(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
		assert((title ?? message) != nil, "Title OR message must be passed in")
		assert(!actions.isEmpty, "Alert actions must not be empty")

		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		for action in actions {
			alertController.addAction(action)
		}
		return alertController
	}
}

extension UIAlertAction {
	static func gotIt(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Got it", style: .default, handler: handler)
	}

	static func ok(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "OK", style: .default, handler: handler)
	}

	static func cancel(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Cancel", style: .cancel, handler: handler)
	}

	static func delete(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Delete", style: .destructive, handler: handler)
	}

	static func allow(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Allow", style: .default, handler: handler)
	}

	static func dontAllow(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Don't Allow", style: .cancel, handler: handler)
	}

	static func yes(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "Yes", style: .default, handler: handler)
	}

	static func no(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		UIAlertAction(title: "No", style: .default, handler: handler)
	}
}

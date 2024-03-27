//
//  NotificationService.swift
//  Pino-Notif-Service
//
//  Created by Sobhan Eskandari on 3/26/24.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
	var contentHandler: ((UNNotificationContent) -> Void)?
	var bestAttemptContent: UNMutableNotificationContent?

	override func didReceive(
		_ request: UNNotificationRequest,
		withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
	) {
		let userInfo = request.content.userInfo

		// Check if the notification is a marketing notification (you'll need to define this mechanism)
		if isMarketingNotification(userInfo) {
			// Check if the user has opted out of marketing notifications
			contentHandler(UNNotificationContent()) // Deliver an empty notification
			return
		}

		// If it's not a marketing notification or the user has opted in, deliver it normally
		contentHandler(request.content)
	}

	private func isMarketingNotification(_ userInfo: [AnyHashable: Any]) -> Bool {
		if let notifInfo = userInfo["type"] as? String,
		   let notifType = NotificaionType(rawValue: notifInfo) {
			return notifType.isAllowed
		} else {
			return true
		}
	}

	override func serviceExtensionTimeWillExpire() {
		// Called just before the extension will be terminated by the system.
		// Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload
		// will be used.
		if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
			contentHandler(bestAttemptContent)
		}
	}
}

enum NotificaionType: String {
	case marketing
	case pinoUpdate
	case activity

	public var isAllowed: Bool {
		UserDefaults.standard.bool(forKey: rawValue)
	}
}

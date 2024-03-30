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
		print("received notif:\(userInfo["type"])")
		// Check if the notification can be shown based on user pref
		if canShowNotif(userInfo) {
			contentHandler(request.content)
			print("received: show")
			return
		} else {
			print("received: NOT show")
		}
	}

	private func canShowNotif(_ userInfo: [AnyHashable: Any]) -> Bool {
		if let notifInfo = userInfo["type"] as? String,
		   let notifType = NotificaionType(rawValue: notifInfo) {
			return notifType.isAllowed
		} else {
			return false
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
	case pinoUpdate
	case activity

	public var isAllowed: Bool {
		let pref = UserDefaults(suiteName: "group.id.notif.service")!
		switch self {
		case .pinoUpdate:
			return pref.bool(forKey: GlobalUserDefaultsKeys.pinoUpdateNotif.rawValue)
		case .activity:
			return pref.bool(forKey: GlobalUserDefaultsKeys.activityNotif.rawValue)
		}
	}
}

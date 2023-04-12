//
//  NotificationsHeaderCollectionReusableView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationSettingsHeader: UICollectionReusableView {
	// MARK: - Public Properties

	public var notificationsVM: NotificationSettingsViewModel? {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let viewReuseID = "notificationsCollectionViewHeaderSection"

	// Closures
	public var changeAllowNotificationsClosure: ((_ isAllowed: Bool) -> Void)!

	// MARK: - Private Properties

	private let collectionViewTitleLabel = PinoLabel(style: .description, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(collectionViewTitleLabel)
	}

	private func setupStyles() {
		collectionViewTitleLabel.text = notificationsVM?.notificationOptionsSectionTitle
		collectionViewTitleLabel.font = .PinoStyle.mediumSubheadline
	}

	private func setupConstraints() {
		collectionViewTitleLabel.pin(.bottom(padding: 8), .horizontalEdges(padding: 16))
	}
}

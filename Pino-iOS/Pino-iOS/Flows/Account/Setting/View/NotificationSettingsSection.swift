//
//  NotificationsHeaderCollectionReusableView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationSettingsSection: UICollectionReusableView {
	// MARK: - Public Properties

	public var sectionTitle: String? {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let viewReuseID = "notificationsCollectionViewHeaderSection"

	// MARK: - Private Properties

	private let collectionViewTitleLabel = PinoLabel(style: .description, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(collectionViewTitleLabel)
	}

	private func setupStyles() {
		collectionViewTitleLabel.text = sectionTitle
		collectionViewTitleLabel.font = .PinoStyle.mediumSubheadline
	}

	private func setupConstraints() {
		collectionViewTitleLabel.pin(.bottom(padding: 8), .horizontalEdges(padding: 16))
	}
}

//
//  NotificationsHeaderCollectionReusableView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationsHeaderCollectionReusableView: UICollectionReusableView {
	// MARK: - Public Properties

	public var notificationsVM: NotificationsViewModel? {
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

	private let mainView = UIView()
	private let optionView = UIView()
	private let optionStackView = UIStackView()
	private let optionTitleLabel = PinoLabel(style: .title, text: "")
	private let switchOption = UISwitch()
	private let collectionViewTitleLabel = PinoLabel(style: .description, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(mainView)

		switchOption.addTarget(self, action: #selector(onChangeAllowNotification), for: .valueChanged)

		optionStackView.addArrangedSubview(optionTitleLabel)
		optionStackView.addArrangedSubview(switchOption)

		optionView.addSubview(optionStackView)

		mainView.addSubview(optionView)
		mainView.addSubview(collectionViewTitleLabel)
	}

	private func setupStyles() {
		collectionViewTitleLabel.text = notificationsVM?.notificationOptionsSectionTitle
		collectionViewTitleLabel.font = .PinoStyle.mediumSubheadline

		optionStackView.axis = .horizontal
		optionStackView.spacing = 8
		optionStackView.alignment = .center

		optionView.backgroundColor = .Pino.white
		optionView.layer.cornerRadius = 8

		optionTitleLabel.text = notificationsVM?.allowNotficationsTitle
		optionTitleLabel.font = .PinoStyle.mediumBody

		switchOption.onTintColor = .Pino.green3
	}

	private func setupConstraints() {
		optionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
		collectionViewTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
		optionTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
		mainView.pin(.horizontalEdges(padding: 16), .top(padding: 24), .bottom(padding: 8))
		optionView.pin(.top(padding: 0), .horizontalEdges(padding: 0))
		optionStackView.pin(.horizontalEdges(padding: 16), .verticalEdges(padding: 0))
		collectionViewTitleLabel.pin(.bottom(padding: 0), .horizontalEdges(padding: 0))
	}

	@objc
	private func onChangeAllowNotification() {
		changeAllowNotificationsClosure(switchOption.isOn)
	}
}

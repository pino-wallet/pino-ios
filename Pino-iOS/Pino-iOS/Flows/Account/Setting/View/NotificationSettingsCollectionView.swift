//
//  NotificationsCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationSettingsCollectionView: UICollectionView {
	// MARK: - Typealiases

	typealias openTooltipAlertType = (_ tooltipTitle: String, _ tooltipText: String) -> Void

	// MARK: - Public Properties

	public let notificationsVM: NotificationSettingsViewModel

	// MARK: - Closures

	public var openTooltipAlert: openTooltipAlertType

	// MARK: - Initializers

	init(notificationsVM: NotificationSettingsViewModel, openTooltipAlert: @escaping openTooltipAlertType) {
		let flowLayout = UICollectionViewFlowLayout(
			scrollDirection: .vertical,
			sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		)
		self.notificationsVM = notificationsVM
		self.openTooltipAlert = openTooltipAlert
		super.init(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.collectionView?.backgroundColor = .Pino.background

		configureCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		register(
			NotificationSettingsCell.self,
			forCellWithReuseIdentifier: NotificationSettingsCell.cellReuseID
		)

		register(
			NotificationSettingsSection.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: NotificationSettingsSection.viewReuseID
		)

		delegate = self
		dataSource = self
	}
}

extension NotificationSettingsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		switch section {
		case 0:
			return CGSize(width: collectionView.frame.width, height: 24)
		case 1:
			return CGSize(width: collectionView.frame.width, height: 78)
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 0)
	}
}

extension NotificationSettingsCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return notificationsVM.generalNotificationOptions.count
		case 1:
			return notificationsVM.notificationOptions.count
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: NotificationSettingsCell.cellReuseID,
			for: indexPath
		) as! NotificationSettingsCell
		switch indexPath.section {
		case 0:
			cell
				.notificationSettingsOptionVM = NotificationSettingsOptionViewModel(
					notificationOption: notificationsVM
						.generalNotificationOptions[indexPath.item]
				)
			cell.manageIndex = (viewIndex: indexPath.item, viewsCount: notificationsVM.generalNotificationOptions.count)
		case 1:
			cell
				.notificationSettingsOptionVM = NotificationSettingsOptionViewModel(
					notificationOption: notificationsVM
						.notificationOptions[indexPath.item]
				)
			cell.onTooltipTapClosure = { [weak self] tooltipTitle, tooltipText in
				self?.openTooltipAlert(tooltipTitle, tooltipText)
			}
			cell.manageIndex = (viewIndex: indexPath.item, viewsCount: notificationsVM.notificationOptions.count)
		default:
			fatalError("Invalid section index in notificaition collection view")
		}

		#warning("this closure is for testing and should be updated")
		cell.switchValueClosure = { isOn, type in
		}
		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch indexPath.section {
		case 0:
			let generalNotificationSettingsHeader = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: GeneralNotificationSettingsHeader.viewReuseID,
				for: indexPath
			)
			return generalNotificationSettingsHeader
		case 1:
			let notificationSettingsHeader = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: NotificationSettingsSection.viewReuseID,
				for: indexPath
			) as! NotificationSettingsSection
			notificationSettingsHeader.notificationsVM = notificationsVM
			#warning("this closure is for testing and should be updated")
			notificationSettingsHeader.changeAllowNotificationsClosure = { isAllowed in
			}

			return notificationSettingsHeader
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}
}

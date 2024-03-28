//
//  NotificationsCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import Combine
import UIKit

class NotificationSettingsCollectionView: UICollectionView {
	// MARK: - Typealiases

	typealias openTooltipAlertType = (_ tooltipTitle: String, _ tooltipText: String) -> Void

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let notificationsVM: NotificationSettingsViewModel

	// MARK: - Closures

	public var openTooltipAlert: openTooltipAlertType

	// MARK: - Initializers

	init(notificationsVM: NotificationSettingsViewModel, openTooltipAlert: @escaping openTooltipAlertType) {
		let flowLayout = UICollectionViewFlowLayout(
			scrollDirection: .vertical,
			sectionInset: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
		)
		self.notificationsVM = notificationsVM
		self.openTooltipAlert = openTooltipAlert
		super.init(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.collectionView?.backgroundColor = .Pino.background
		self.contentInset = .init(top: 24, left: 16, bottom: 0, right: 16)

		configureCollectionView()
		setupBinding()
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

	private func setupBinding() {
		notificationsVM.$isNotifAllowed.sink { allowed in
			self.reloadData()
		}.store(in: &cancellables)
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
			return CGSize(width: collectionView.frame.width, height: 0)
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
		CGSize(width: collectionView.frame.width - 32, height: 48)
	}
}

extension NotificationSettingsCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		notificationsVM.isNotifAllowed ? 2 : 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return notificationsVM.getGeneralNotifOptions().count
		case 1:
			return notificationsVM.getNotifOptions().count
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
						.getGeneralNotifOptions()[indexPath.item]
				)
			cell.manageIndex = (viewIndex: indexPath.item, viewsCount: notificationsVM.getGeneralNotifOptions().count)
		case 1:
			cell
				.notificationSettingsOptionVM = NotificationSettingsOptionViewModel(
					notificationOption: notificationsVM
						.getNotifOptions()[indexPath.item]
				)
			cell.onTooltipTapClosure = { [weak self] tooltipTitle, tooltipText in
				self?.openTooltipAlert(tooltipTitle, tooltipText)
			}
			cell.manageIndex = (viewIndex: indexPath.item, viewsCount: notificationsVM.getNotifOptions().count)

		default:
			fatalError("Invalid section index in notificaition collection view")
		}

		cell.switchValueClosure = { [unowned self] isOn, type in
			let notifType = NotificationOptionModel.NotificationOption(rawValue: type)!
			notificationsVM.saveNotifSettings(isOn: isOn, notifType: notifType)
		}

		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let notificationSettingsHeader = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: NotificationSettingsSection.viewReuseID,
			for: indexPath
		) as! NotificationSettingsSection
		notificationSettingsHeader.sectionTitle = notificationsVM.notificationOptionsSectionTitle
		return notificationSettingsHeader
	}
}

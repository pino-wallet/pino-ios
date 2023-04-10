//
//  NotificationsCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import UIKit

class NotificationsCollectionView: UICollectionView {
	// MARK: - Typealiases

	typealias openTooltipAlertType = (_ tooltipTitle: String, _ tooltipText: String) -> Void

	// MARK: - Public Properties

	public let notificationsVM: NotificationsViewModel

	// MARK: - Closures

	public var openTooltipAlert: openTooltipAlertType

	// MARK: - Initializers

	init(notificationsVM: NotificationsViewModel, openTooltipAlert: @escaping openTooltipAlertType) {
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
			CustomSwitchCollectionViewCell.self,
			forCellWithReuseIdentifier: CustomSwitchCollectionViewCell.cellReuseID
		)

		register(
			NotificationsHeaderCollectionReusableView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: NotificationsHeaderCollectionReusableView.viewReuseID
		)

		delegate = self
		dataSource = self
	}
}

extension NotificationsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 152)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 48)
	}
}

extension NotificationsCollectionView: UICollectionViewDelegate {}

extension NotificationsCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		notificationsVM.notificationOptions.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: CustomSwitchCollectionViewCell.cellReuseID,
			for: indexPath
		) as! CustomSwitchCollectionViewCell
		cell
			.customSwitchCollectionViewCellVM = NotificationOptionViewModel(
				notificationOption: notificationsVM
					.notificationOptions[indexPath.item]
			)
		cell.manageIndex = (cellIndex: indexPath.item, cellsCount: notificationsVM.notificationOptions.count)
		cell.onTooltipTapClosure = { [weak self] tooltipTitle, tooltipText in
			self?.openTooltipAlert(tooltipTitle, tooltipText)
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
		let headerView = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: NotificationsHeaderCollectionReusableView.viewReuseID,
			for: indexPath
		) as! NotificationsHeaderCollectionReusableView
		headerView.notificationsVM = notificationsVM
		#warning("this closure is for testing and should be updated")
		headerView.changeAllowNotificationsClosure = { isAllowed in
		}

		return headerView
	}
}

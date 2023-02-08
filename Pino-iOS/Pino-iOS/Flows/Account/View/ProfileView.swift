//
//  ProfileView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import UIKit

class ProfileCollectionView: UICollectionView {
	// MARK: Private Properties

	private let profileVM: ProfileViewModel

	// MARK: Initializers

	init(profileVM: ProfileViewModel) {
		self.profileVM = profileVM
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(
			SettingCell.self,
			forCellWithReuseIdentifier: SettingCell.cellReuseID
		)
		register(
			AccountHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: AccountHeaderView.headerReuseID
		)
		register(
			SettingsHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SettingsHeaderView.headerReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.clear
		showsVerticalScrollIndicator = false
	}

	private func settingCellStyle(currentItem: Int, totalItems: Int) -> SettingCell.Style {
		if totalItems == 1 {
			return .singleCell
		} else if currentItem == 0 {
			return .firstCell
		} else if (currentItem + 1) == totalItems {
			return .lastCell
		} else {
			return .regular
		}
	}
}

// MARK: Collection View Flow Layout

extension ProfileCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 48)
	}
}

extension ProfileCollectionView: UICollectionViewDataSource {
	// MARK: - CollectionView DataSource Methods

	internal func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return profileVM.accountSettings.count
		case 1:
			return profileVM.generalSettings.count
		default:
			return .zero
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let settingCell = dequeueReusableCell(
			withReuseIdentifier: SettingCell.cellReuseID,
			for: indexPath
		) as! SettingCell
		switch indexPath.section {
		case 0:
			settingCell.settingVM = profileVM.accountSettings[indexPath.item]
			settingCell.style = settingCellStyle(
				currentItem: indexPath.item,
				totalItems: profileVM.accountSettings.count
			)
		case 1:
			settingCell.settingVM = profileVM.generalSettings[indexPath.item]
			settingCell.style = settingCellStyle(
				currentItem: indexPath.item,
				totalItems: profileVM.generalSettings.count
			)
		default: break
		}
		return settingCell
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			switch indexPath.section {
			case 0:
				// Account header
				let accountHeaderView = dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: AccountHeaderView.headerReuseID,
					for: indexPath
				) as! AccountHeaderView
				accountHeaderView.walletInfoVM = profileVM.walletInfo
				return accountHeaderView

			case 1:
				// Settings header
				let settingsHeaderView = dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: SettingsHeaderView.headerReuseID,
					for: indexPath
				) as! SettingsHeaderView
				settingsHeaderView.title = "General settings"
				return settingsHeaderView

			default:
				fatalError("Invalid element type")
			}
		default:
			fatalError("Invalid element type")
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		switch section {
		case 0:
			return CGSize(width: collectionView.frame.width, height: 240)
		case 1:
			return CGSize(width: collectionView.frame.width, height: 64)
		default:
			return .zero
		}
	}
}

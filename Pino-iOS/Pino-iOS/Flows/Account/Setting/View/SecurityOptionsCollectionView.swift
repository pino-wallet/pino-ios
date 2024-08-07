//
//  SecurityLockTypeCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class SecurityOptionsCollectionView: UICollectionView {
	// MARK: - Closures

	public var openSelectLockMethodAlertClosure: () -> Void

	// MARK: - Public Peoperties

	public let securityLockVM: SecuritySettingsViewModel

	// MARK: - Initializers

	init(securityLockVM: SecuritySettingsViewModel, openSelectLockMethodAlertClosure: @escaping () -> Void) {
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.securityLockVM = securityLockVM
		self.openSelectLockMethodAlertClosure = openSelectLockMethodAlertClosure
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
			SecurityOptionCell.self,
			forCellWithReuseIdentifier: SecurityOptionCell.cellReuseID
		)
		register(
			SecurityOptionsSection.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SecurityOptionsSection.viewReuseID
		)
		register(
			SecurityOptionsFooter.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: SecurityOptionsFooter.viewReuseID
		)

		delegate = self
		dataSource = self
	}
}

extension SecurityOptionsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 0)
	}

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
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 32)
	}
}

extension SecurityOptionsCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		securityLockVM.securityOptions.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let currentOption = securityLockVM.securityOptions[indexPath.item]
		let cell = dequeueReusableCell(
			withReuseIdentifier: SecurityOptionCell.cellReuseID,
			for: indexPath
		) as! SecurityOptionCell
		cell
			.securityOptionVM = SecurityOptionViewModel(
				lockSettingOption: currentOption
			)
		cell.manageIndex = (viewIndex: indexPath.item, viewsCount: securityLockVM.securityOptions.count)
		cell.switchValueClosure = { isOn, type in
			self.securityLockVM.changeSecurityModes(isOn: isOn, type: type)
			for (index, option) in self.securityLockVM.securityOptions.enumerated() {
				if option.type.rawValue != type {
					UIView.performWithoutAnimation {
						self.reloadItems(at: [IndexPath(item: index, section: indexPath.section)])
					}
				}
			}
		}

		let currentSecurityModes = UserDefaultsManager.securityModesUser.getValue()
		if let currentSecurityModes,
		   currentSecurityModes.count == 1 && currentSecurityModes[0] == currentOption.type.rawValue {
			cell.isEnabled = false
		} else {
			cell.isEnabled = true
		}

		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let headerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: SecurityOptionsSection.viewReuseID,
				for: indexPath
			) as! SecurityOptionsSection

			headerView.securityVM = securityLockVM
			headerView.openSelectLockMethodAlertClosure = openSelectLockMethodAlertClosure

			return headerView
		case UICollectionView.elementKindSectionFooter:
			let footerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionFooter,
				withReuseIdentifier: SecurityOptionsFooter.viewReuseID,
				for: indexPath
			) as! SecurityOptionsFooter

			footerView.securityVM = securityLockVM

			return footerView
		default:
			fatalError("cant dequeue reusable view")
		}
	}
}

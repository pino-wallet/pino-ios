//
//  SecurityLockTypeCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class AuthenticationOptionsCollectionView: UICollectionView {
	// MARK: - Closures

	public var openSelectLockMethodAlertClosure: () -> Void

	// MARK: - Public Peoperties

	public let securityLockVM: SecurityLockViewModel

	// MARK: - Initializers

	init(securityLockVM: SecurityLockViewModel, openSelectLockMethodAlertClosure: @escaping () -> Void) {
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
			AuthenticationOptionCell.self,
			forCellWithReuseIdentifier: AuthenticationOptionCell.cellReuseID
		)
		register(
			AuthenticationOptionsSection.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: AuthenticationOptionsSection.viewReuseID
		)
		register(
			AuthenticationOptionsFooter.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: AuthenticationOptionsFooter.viewReuseID
		)

		delegate = self
		dataSource = self
	}
}

extension AuthenticationOptionsCollectionView: UICollectionViewDelegateFlowLayout {
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

extension AuthenticationOptionsCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		securityLockVM.authenticationOptions.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: AuthenticationOptionCell.cellReuseID,
			for: indexPath
		) as! AuthenticationOptionCell
		cell
			.lockSettingVM = LockSettingViewModel(
				lockSettingOption: securityLockVM
					.authenticationOptions[indexPath.item]
			)
		cell.manageIndex = (viewIndex: indexPath.item, viewsCount: securityLockVM.authenticationOptions.count)
		cell.switchValueClosure = { isOn, type in
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
				withReuseIdentifier: AuthenticationOptionsSection.viewReuseID,
				for: indexPath
			) as! AuthenticationOptionsSection

			headerView.securityLockVM = securityLockVM
			headerView.openSelectLockMethodAlertClosure = openSelectLockMethodAlertClosure

			return headerView
		case UICollectionView.elementKindSectionFooter:
			let footerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionFooter,
				withReuseIdentifier: AuthenticationOptionsFooter.viewReuseID,
				for: indexPath
			) as! AuthenticationOptionsFooter

			footerView.securityLockVM = securityLockVM

			return footerView
		default:
			fatalError("cant dequeue reusable view")
		}
	}
}

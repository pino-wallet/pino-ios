//
//  LockSettingsFooterCollectionReusableView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/3/23.
//

import UIKit

class LockSettingsFooterCollectionReusableView: UICollectionReusableView {
	// MARK: - Public Properties

	public var securityLockVM: SecurityLockViewModel! {
		didSet {
			setupView()
			setupConstraints()
			setupStyle()
		}
	}

	public static let viewReuseID = "LockSettingsFooterReuseID"

	// MARK: - Private Properties

	private let lockSettingsFooterLaebl = PinoLabel(style: .description, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(lockSettingsFooterLaebl)
	}

	private func setupConstraints() {
		lockSettingsFooterLaebl.pin(.leading(padding: 32), .top(padding: 10), .trailing(padding: 0))
	}

	private func setupStyle() {
		lockSettingsFooterLaebl.text = securityLockVM.lockSettingsFooterTitle
		lockSettingsFooterLaebl.font = .PinoStyle.mediumSubheadline
	}
}

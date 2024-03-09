//
//  LockSettingsCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/11/23.
//

import UIKit

class SecurityOptionCell: UICollectionViewCell {
	// MARK: - Public Properties

	public var securityOptionVM: SecurityOptionViewModel! {
		didSet {
			setupView()
			setupConstraints()
		}
	}

	public static let cellReuseID = "locksettingsSettingsCellReuseID"

	public var manageIndex: CustomSwitchOptionView.manageIndexType! {
		didSet {
			customSwitchOptionView.manageIndex = manageIndex
		}
	}
    
    public var isEnabled: Bool? {
        didSet {
            guard let isEnabled else {
                return
            }
            customSwitchOptionView.isEnabled = isEnabled
        }
    }

	// MARK: - Closures

	public var switchValueClosure: CustomSwitchOptionView.switchValueClosureType!
	public var onTooltipTapClosure: CustomSwitchOptionView.onTooltipTapClosureType!

	// MARK: - Private Properties

	private let customSwitchOptionView = CustomSwitchOptionView()

	// MARK: - Private Methods

	private func setupView() {
		customSwitchOptionView.customSwitchCollectionViewCellVM = securityOptionVM
		customSwitchOptionView.switchValueClosure = { [weak self] isOn, type in
			self?.switchValueClosure(isOn, type)
		}
		customSwitchOptionView.onTooltipTapClosure = { [weak self] tooltipTitle, tooltipText in
			self?.onTooltipTapClosure(tooltipTitle, tooltipText)
		}
		contentView.addSubview(customSwitchOptionView)
	}

	private func setupConstraints() {
		customSwitchOptionView.pin(.allEdges(padding: 0))
	}
}

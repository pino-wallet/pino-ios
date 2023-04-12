//
//  NotificationSettingsCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/11/23.
//

import UIKit

class NotificationSettingsCell: UICollectionViewCell {
	// MARK: - Public Properties

	public var notificationSettingsOptionVM: NotificationSettingsOptionViewModel! {
		didSet {
			setupView()
			setupConstraints()
		}
	}

	public var manageIndex: CustomSwitchOptionView.manageIndexType! {
		didSet {
			customSwitchOptionView.manageIndex = manageIndex
		}
	}

	public static let cellReuseID = "notificationSettingsCellReuseID"

	// MARK: - Closures

	public var switchValueClosure: CustomSwitchOptionView.switchValueClosureType!
	public var onTooltipTapClosure: CustomSwitchOptionView.onTooltipTapClosureType!

	// MARK: - Private Properties

	let customSwitchOptionView = CustomSwitchOptionView()

	// MARK: - Private Methods

	private func setupView() {
		customSwitchOptionView.customSwitchCollectionViewCellVM = notificationSettingsOptionVM
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

//
//  SecurityLockViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

class SecurityLockViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Security lock"
	public let changeLockMethodTitle = "Lock method"
	public let changeLockMethodDetailIcon = "arrow_right"
	public let changeLockMethodAlertTitle = "Select the security method"
	public let lockSettingsHeaderTitle = "Required authentication"
	public let lockSettingsFooterTitle = "At least one option should be selected."
	public let alertCancelButtonTitle = "Cancel"
	public let lockMethods = [
		LockMethodModel(title: "Passcode", type: .passcode),
		LockMethodModel(title: "Face ID", type: .face_id),
	]
	public let lockSettings = [
		LockSettingModel(title: "Immediately", type: .immediately, isSelected: true),
		LockSettingModel(title: "Make a transaction", type: .on_transactions, isSelected: false),
	]

	// MARK: - Public Methods

	public func changeLockMethod(type: LockMethodModel.LockMethodType) {}
}

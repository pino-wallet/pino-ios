//
//  SecurityLockViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import Foundation

class SecurityViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Security"
	public let changeLockMethodTitle = "Lock method"
	public let changeLockMethodDetailIcon = "chevron_right"
	public let changeLockMethodAlertTitle = "Select the security method"
	public let lockSettingsHeaderTitle = "Required authentication"
	public let lockSettingsFooterTitle = "At least one option should be selected."
	public let alertCancelButtonTitle = "Cancel"
	public let lockMethods = [
		LockMethodModel(title: "Face ID", type: .face_id),
		LockMethodModel(title: "Passcode", type: .passcode),
	]
	public let securityOptions = [
		SecurityOptionModel(title: "Immediately", type: .immediately, isSelected: true, description: nil),
		SecurityOptionModel(
			title: "For every transaction",
			type: .on_transactions,
			isSelected: false,
			description: nil
		),
	]

	@Published
	public var selectedLockMethod: LockMethodModel!

	init() {
		self.selectedLockMethod = getLockMethod()
	}

	// MARK: - Private Methods

	private func getLockMethod() -> LockMethodModel {
        let defaultLockMethod = LockMethodType.passcode
		let savedLockMethodType = UserDefaults.standard.string(forKey: "lockMethodType") ?? defaultLockMethod.rawValue
		let lockMethodType = LockMethodType(rawValue: savedLockMethodType) ?? defaultLockMethod
		return lockMethods.first(where: { $0.type == lockMethodType })!
	}

	// MARK: - Public Methods

	public func changeLockMethod(to lockMethod: LockMethodModel) {
		selectedLockMethod = lockMethod
		UserDefaults.standard.set(lockMethod.type.rawValue, forKey: "lockMethodType")
	}
}

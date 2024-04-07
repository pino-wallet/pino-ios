//
//  SecurityLockViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import Foundation

class SecuritySettingsViewModel {
	// MARK: - Private Properties

	private var defaultSecurityModes: [String] {
		UserDefaultsManager.securityModesUser.getValue() ?? []
	}

	// MARK: - Public Properties

	public let pageTitle = "Security lock"
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
	public var securityOptions: [SecurityOptionModel] {
		[
			SecurityOptionModel(
				title: "Immediately",
				type: .immediately,
				isSelected: defaultSecurityModes
					.first(where: { $0 == SecurityOptionModel.LockType.immediately.rawValue }) != nil,
				description: nil
			),
			SecurityOptionModel(
				title: "Make a transaction",
				type: .on_transactions,
				isSelected: defaultSecurityModes
					.first(where: { $0 == SecurityOptionModel.LockType.on_transactions.rawValue }) != nil,
				description: nil
			),
		]
	}

	@Published
	public var selectedLockMethod: LockMethodModel!

	init() {
		self.selectedLockMethod = getLockMethod()
	}

	// MARK: - Private Methods

	private func getLockMethod() -> LockMethodModel {
		let defaultLockMethod = LockMethodType.passcode
		let savedLockMethodType: String = UserDefaultsManager.lockMethodType.getValue() ?? defaultLockMethod.rawValue
		let lockMethodType = LockMethodType(rawValue: savedLockMethodType) ?? defaultLockMethod
		return lockMethods.first(where: { $0.type == lockMethodType })!
	}

	// MARK: - Public Methods

	public func changeLockMethod(to lockMethod: LockMethodModel) {
		selectedLockMethod = lockMethod
		UserDefaultsManager.lockMethodType.setValue(value: lockMethod.type.rawValue)
	}

	public func changeSecurityModes(isOn: Bool, type: String) {
		var currentSecurityModes: [String] = UserDefaultsManager.securityModesUser.getValue() ?? []
		guard let currentModeIndex = currentSecurityModes.firstIndex(where: { $0 == type }) else {
			if isOn {
				currentSecurityModes.append(type)
				UserDefaultsManager.securityModesUser.setValue(value: currentSecurityModes)
			} else {
				fatalError("Cannot modify security mode list")
			}
			return
		}

		if !isOn {
			currentSecurityModes.remove(at: currentModeIndex)
			UserDefaultsManager.securityModesUser.setValue(value: currentSecurityModes)
		} else {
			fatalError("Cannot modify security mode list")
		}
	}
}

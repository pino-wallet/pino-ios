//
//  SyncWalletViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/1/24.
//

import Foundation
import PromiseKit

class SyncWalletViewModel {
	// MARK: - Public Properties

	public let titleAnimationName = "SyncWallet"
	public let titleText = "Synchronizing..."
	public let titleFinishedText = "Synced successfully!"
	public let descriptionText = "We are syncing your wallet data. This may take a few minutes."
	public let descriptionFinishedText = "Your wallet is now set up and ready to use in the DeFi world."
	public let exploreTitleText = "Do you want to explore Pino in the meantime?"
	public let explorePinoBtnText = "OK, let’s go!"
	public let explorePinoFinishedBtnText = "OK, let’s go!"
	public var loadingTime: TimeInterval = 15

	@Published
	public var syncStatus: SyncStatus = .syncing

	public static var isSyncFinished: Bool {
		guard let syncFinishTime = UserDefaultsManager.syncFinishTime.getValue() else { return true }
		if Date.now > syncFinishTime {
			return true
		} else {
			return false
		}
	}

	// MARK: - Public Properties

	public static func showToastIfSyncIsNotFinished() {
		if !isSyncFinished {
			Toast.default(title: "Working on your data ...", style: .secondary).show()
		}
	}

	// MARK: - Initializers
}

extension SyncWalletViewModel {
	public enum SyncStatus {
		case syncing
		case finished
	}
}

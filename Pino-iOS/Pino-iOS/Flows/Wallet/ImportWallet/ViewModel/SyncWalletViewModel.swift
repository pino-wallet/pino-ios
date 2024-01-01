//
//  SyncWalletViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/1/24.
//

import Foundation

struct SyncWalletViewModel {
	// MARK: - Public Properties

	#warning("this image should change to lottie later")
	public let titleImageName = "sync_wallet"
	public let titleText = "Synchronizing..."
	public let descriptionText = "We are syncing your wallet data. This may take a few minutes."
	public let exploreTitleText = "Do you want to explore Pino in the meantime?"
	public let explorePinoButtonText = "Explore Pino"
	public var loadingTime: TimeInterval

	// MARK: - Initializers

	init(loadingTime: TimeInterval) {
		self.loadingTime = loadingTime
	}
}

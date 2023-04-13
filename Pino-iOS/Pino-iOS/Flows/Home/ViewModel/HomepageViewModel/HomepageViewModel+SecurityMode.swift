//
//  HomepageViewModel+SecurityMode.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/13/23.
//

import Foundation

extension HomepageViewModel {
	// MARK: Internal Methods

	internal func enableSecurityMode() {
		walletBalance.enableSecurityMode()
		guard let assetsList else { return }

		for asset in assetsList {
			asset.enableSecurityMode()
		}
		for asset in positionAssetsList {
			asset.enableSecurityMode()
		}

		self.assetsList = assetsList
		positionAssetsList = positionAssetsList
	}

	internal func disableSecurityMode() {
		walletBalance.disableSecurityMode()
		guard let assetsList else { return }

		for asset in assetsList {
			asset.disableSecurityMode()
		}
		for asset in positionAssetsList {
			asset.disableSecurityMode()
		}

		self.assetsList = assetsList
		positionAssetsList = positionAssetsList
	}
}

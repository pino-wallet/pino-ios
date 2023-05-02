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
		guard walletBalance != nil else { return }
		walletBalance!.enableSecurityMode()
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
		guard walletBalance != nil else { return }
		walletBalance!.disableSecurityMode()
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

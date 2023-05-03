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

		if let assetsList {
			for asset in assetsList {
				asset.enableSecurityMode()
			}
		}
		if let positionAssetsList {
			for asset in positionAssetsList {
				asset.enableSecurityMode()
			}
		}
		assetsList = assetsList
		positionAssetsList = positionAssetsList
	}

	internal func disableSecurityMode() {
		guard walletBalance != nil else { return }
		walletBalance!.disableSecurityMode()

		if let assetsList {
			for asset in assetsList {
				asset.disableSecurityMode()
			}
		}

		if let positionAssetsList {
			for asset in positionAssetsList {
				asset.disableSecurityMode()
			}
		}
		assetsList = assetsList
		positionAssetsList = positionAssetsList
	}
}

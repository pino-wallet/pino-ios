//
//  SwapViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class SwapViewController: UIViewController {
	// MARK: - Private Properties

	private var assets: [AssetViewModel]!
	private var swapVM: SwapViewModel!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		assets = HomepageViewModel.sharedAssets
		swapVM = SwapViewModel(payToken: assets[0], getToken: assets[1])
		view = SwapView(
			swapVM: swapVM,
			changePayToken: {
				self.changeSelectedAsset { selectedAsset in
					self.swapVM.payToken.selectedToken = selectedAsset
				}
			},
			changeGetToken: {
				self.changeSelectedAsset { selectedAsset in
					self.swapVM.getToken.selectedToken = selectedAsset
				}
			},
			nextButtonTapped: {}
		)
	}

	private func changeSelectedAsset(assetChanged: @escaping (AssetViewModel) -> Void) {
		let selectAssetVC = SelectAssetToSendViewController(assets: assets)
		selectAssetVC.changeAssetFromEnterAmountPage = { selectedAsset in
			assetChanged(selectedAsset)
		}
		let selectAssetNavigationController = UINavigationController(rootViewController: selectAssetVC)
		present(selectAssetNavigationController, animated: true)
	}
}

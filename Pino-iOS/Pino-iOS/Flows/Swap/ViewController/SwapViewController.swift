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
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		#warning("Temporary list must be replaced with the correct list later")
		assets = HomepageViewModel.sharedAssets
		swapVM = SwapViewModel(fromToken: assets[0], toToken: assets[1])

		view = SwapView(
			swapVM: swapVM,
			changePayToken: {
				self.changePayToken()
			},
			changeGetToken: {
				self.changeGetToken()
			},
			nextButtonTapped: {}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(swapVM.pageTitle)
	}

	private func openSelectAssetPage(assets: [AssetViewModel], assetChanged: @escaping (AssetViewModel) -> Void) {
		let selectAssetVC = SelectAssetToSendViewController(assets: assets)
		selectAssetVC.changeAssetFromEnterAmountPage = { selectedAsset in
			assetChanged(selectedAsset)
		}
		let selectAssetNavigationController = UINavigationController(rootViewController: selectAssetVC)
		present(selectAssetNavigationController, animated: true)
	}

	private func changePayToken() {
		var filteredAssets = assets!.filter { !$0.holdAmount.isZero }
		// To prevent swapping same tokens
		filteredAssets.removeAll(where: { $0.id == swapVM.toToken.selectedToken.id })
		openSelectAssetPage(assets: filteredAssets) { selectedToken in
			self.swapVM.changeSelectedToken(self.swapVM.fromToken, to: selectedToken)
		}
	}

	private func changeGetToken() {
		var filteredAssets = assets!
		// To prevent swapping same tokens
		filteredAssets.removeAll(where: { $0.id == swapVM.fromToken.selectedToken.id })
		openSelectAssetPage(assets: filteredAssets) { selectedToken in
			self.swapVM.changeSelectedToken(self.swapVM.toToken, to: selectedToken)
		}
	}
}

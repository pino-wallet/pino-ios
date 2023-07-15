//
//  SwapViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import Combine
import UIKit

class SwapViewController: UIViewController {
	// MARK: - Private Properties

	private var assets: [AssetViewModel]?
	private var swapVM: SwapViewModel!

	private var cancellables = Set<AnyCancellable>()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupBinding()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView(assetList: [AssetViewModel]) {
		assets = assetList
		swapVM = SwapViewModel(fromToken: assetList[0], toToken: assetList[1])

		view = SwapView(
			swapVM: swapVM,
			fromTokenChange: {
				self.selectAssetForFromToken()
			},
			toTokeChange: {
				self.selectAssetForToToken()
			},
			swapProtocolChange: {
				self.openSelectProtocolPage()
			},
			providerChange: {
				self.openProvidersPage()
			},
			nextButtonTapped: {
				self.openConfirmationPage()
			}
		)
	}

	private func setupBinding() {
		GlobalVariables.shared.$manageAssetsList.sink { assetList in
			if let assetList, self.assets == nil {
				self.setupView(assetList: assetList)
			}
		}.store(in: &cancellables)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("Swap")
	}

	private func openSelectProtocolPage() {
		let swapProtocolVC = SelectSwapProtocolViewController { selectedProtocol in
			self.swapVM.changeSwapProtocol(to: selectedProtocol)
		}
		let swapProtocolNavigationVC = UINavigationController(rootViewController: swapProtocolVC)
		present(swapProtocolNavigationVC, animated: true)
	}

	private func selectAssetForFromToken() {
		var filteredAssets = assets!.filter { !$0.holdAmount.isZero }
		// To prevent swapping same tokens
		filteredAssets.removeAll(where: { $0.id == swapVM.toToken.selectedToken.id })
		openSelectAssetPage(assets: filteredAssets) { selectedToken in
			self.swapVM.changeSelectedToken(self.swapVM.fromToken, to: selectedToken)
		}
	}

	private func selectAssetForToToken() {
		var filteredAssets = assets!
		// To prevent swapping same tokens
		filteredAssets.removeAll(where: { $0.id == swapVM.fromToken.selectedToken.id })
		openSelectAssetPage(assets: filteredAssets) { selectedToken in
			self.swapVM.changeSelectedToken(self.swapVM.toToken, to: selectedToken)
		}
	}

	private func openSelectAssetPage(assets: [AssetViewModel], assetChanged: @escaping (AssetViewModel) -> Void) {
		let selectAssetVC = SelectAssetToSendViewController(assets: assets)
		selectAssetVC.changeAssetFromEnterAmountPage = { selectedAsset in
			assetChanged(selectedAsset)
		}
		let selectAssetNavigationController = UINavigationController(rootViewController: selectAssetVC)
		present(selectAssetNavigationController, animated: true)
	}

	private func openProvidersPage() {
		let providersVC = SwapProvidersViewcontroller { provider in
			self.swapVM.swapFeeVM.swapProviderVM = provider
		}
		present(providersVC, animated: true)
	}

	private func openConfirmationPage() {
		let confirmationVC = SwapConfirmationViewController()
		let confirmationNavigationVC = UINavigationController(rootViewController: confirmationVC)
		present(confirmationNavigationVC, animated: true)
	}
}

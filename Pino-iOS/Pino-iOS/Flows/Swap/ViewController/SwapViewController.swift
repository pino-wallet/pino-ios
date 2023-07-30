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
	private var swapView: SwapView!
	private let protocolChangeButton = UIButton()
	private let pageTitleLabel = UILabel()

	private var cancellables = Set<AnyCancellable>()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupStyle()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = SwapLoadingView()
		GlobalVariables.shared.$manageAssetsList.compactMap { $0 }.sink { assetList in
			if self.assets == nil {
				self.swapVM = SwapViewModel(fromToken: assetList[0], toToken: assetList[1])
				self.swapView = SwapView(
					swapVM: self.swapVM,
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
				self.view = self.swapView
				self.setupBinding()
			} else {
				guard let selectedToken = assetList.first(where: { $0.id == self.swapVM.fromToken.selectedToken.id })
				else { return }
				self.swapVM.fromToken.selectedToken = selectedToken
			}
			self.assets = assetList
		}.store(in: &cancellables)
	}

	private func setupStyle() {
		pageTitleLabel.text = "Swap"
		pageTitleLabel.textColor = .Pino.white
		pageTitleLabel.font = .PinoStyle.semiboldBody

		protocolChangeButton.setImage(UIImage(named: "chevron_down"), for: .normal)
		protocolChangeButton.setTitleColor(.Pino.white, for: .normal)
		protocolChangeButton.tintColor = .Pino.white
		protocolChangeButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 3, imagePlacement: .trailing)

		protocolChangeButton.addAction(UIAction(handler: { _ in
			self.openSelectProtocolPage()
		}), for: .touchUpInside)
	}

	private func setupBinding() {
		swapVM.$selectedProtocol.sink { selectedProtocol in
			self.protocolChangeButton.setTitle(selectedProtocol.name, for: .normal)
		}.store(in: &cancellables)

		swapView.$keyboardIsOpen.sink { keyboardIsOpen in
			if keyboardIsOpen {
				self.hideProtocolCard()
				self.swapView.closeFeeCard()
			} else {
				self.showProtocolCard()
				self.swapView.openFeeCard()
			}
		}.store(in: &cancellables)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		// show navbar protocol button in small devices
		if DeviceHelper.shared.size == .normal {
			navigationItem.titleView = pageTitleLabel
		} else {
			navigationItem.titleView = protocolChangeButton
		}
	}

	private func showProtocolCard() {
		// show and hide protocol card in normal size devices
		if DeviceHelper.shared.size == .normal {
			showPageTitleInNavbar()
			swapView.showProtocolView()
		}
	}

	private func hideProtocolCard() {
		// show and hide protocol card in normal size devices
		if DeviceHelper.shared.size == .normal {
			showProtocolButtonInNavbar()
			swapView.hideProtocolView()
		}
	}

	private func showProtocolButtonInNavbar() {
		navigationItem.titleView = protocolChangeButton
	}

	private func showPageTitleInNavbar() {
		navigationItem.titleView = pageTitleLabel
	}

	private func openSelectProtocolPage() {
		let swapProtocolVC = SelectSwapProtocolViewController { selectedProtocol in
			self.swapVM.changeSwapProtocol(to: selectedProtocol)
		}
		let swapProtocolNavigationVC = UINavigationController(rootViewController: swapProtocolVC)
		present(swapProtocolNavigationVC, animated: true)
	}

	private func selectAssetForFromToken() {
		var filteredAssets = assets!.filter { !$0.holdAmount.isZero && $0.isVerified }
		// To prevent swapping same tokens
		filteredAssets.removeAll(where: { $0.id == swapVM.toToken.selectedToken.id })
		openSelectAssetPage(assets: filteredAssets) { selectedToken in
			self.swapVM.changeSelectedToken(self.swapVM.fromToken, to: selectedToken)
		}
	}

	private func selectAssetForToToken() {
		var filteredAssets = assets!.filter { $0.isVerified }
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
			self.swapVM.changeSwapProvider(to: provider)
		}
		present(providersVC, animated: true)
	}

	private func openConfirmationPage() {
		let swapConfirmationVM = SwapConfirmationViewModel(
			fromToken: swapVM.fromToken,
			toToken: swapVM.toToken,
			selectedProtocol: swapVM.selectedProtocol,
			selectedProvider: swapVM.swapFeeVM.swapProviderVM,
			swapRate: swapVM.swapFeeVM.calculatedAmount!
		)
		let confirmationVC = SwapConfirmationViewController(swapConfirmationVM: swapConfirmationVM)
		let confirmationNavigationVC = UINavigationController(rootViewController: confirmationVC)
		present(confirmationNavigationVC, animated: true)
	}
}

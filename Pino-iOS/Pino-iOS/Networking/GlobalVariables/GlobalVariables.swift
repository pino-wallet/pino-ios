//
//  GlobalVariables.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/28/23.
//

import Combine
import Foundation
import PromiseKit

class GlobalVariables {
	// MARK: - Public Shared Accessor

	public static let shared = GlobalVariables()

	// MARK: - Public Properties

	@Published
	public var ethGasFee: EthBaseFeeModel?
	@Published
	public var manageAssetsList: [AssetViewModel]?
	@Published
	public var selectedManageAssetsList: [AssetViewModel]?
	@Published
	public var currentAccount: WalletAccount!
	public var positionAssetDetailsList: [PositionAssetModel]?

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()
	private var internetConnectivity = InternetConnectivity()
	private let web3Client = Web3APIClient()

	// MARK: - Private Initializer

	private init() {
		calculateEthGasFee()
		self.currentAccount = PinoWalletManager().currentAccount
		setupBindings()
	}

	public func updateCurrentAccount(_ newAccount: WalletAccount) {
		// Cancel all active timers and requests
		cancellables.removeAll()
		manageAssetsList = nil
		selectedManageAssetsList = nil
		currentAccount = newAccount
		fetchBalances()
		setupBindings()
	}

	@discardableResult
	public func fetchSharedInfo() -> Promise<Void> {
		print("== SENDING REQUEST ==")
		return firstly {
			self.checkEthFee()
		}.then { _ in
			self.getManageAssetLists()
		}.then { assets in
			self.getPositoinsDetail().map { (assets, $0) }
		}.done { assets, positions in
			self.positionAssetDetailsList = positions
			self.manageAssetsList = assets
		}
	}

	// MARK: - Private Methods

	private func isNetConnected() -> AnyPublisher<Bool, Error> {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.eraseToAnyPublisher()
	}

	private func checkInternetConnectivity(completion: @escaping (Bool) -> Void) {
		Timer.publish(every: 11, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
				isNetConnected().sink { _ in
				} receiveValue: { isConnected in
					completion(isConnected)
				}.store(in: &cancellables)
			}
			.store(in: &cancellables)
	}

	private func fetchBalances() {
		fetchSharedInfo().catch { error in
			self.showError(error)
		}
	}

	private func calculateEthGasFee() {
		Timer.publish(every: 6, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
				getEthGasFee().catch { error in
					// Show toast
				}
			}.store(in: &cancellables)
	}

	private func getManageAssetLists() -> Promise<[AssetViewModel]> {
		AssetManagerViewModel.shared.getAssetsList()
	}

	private func getPositoinsDetail() -> Promise<[PositionAssetModel]> {
		AssetManagerViewModel.shared.getPositionAssetDetails()
	}

	private func getEthGasFee() -> Promise<EthGasInfoModel> {
		Promise<EthGasInfoModel> { seal in
			if let ethGasFee = self.ethGasFee {
				self.ethGasFee = EthBaseFeeModel(baseFeeModel: ethGasFee.baseFeeModel, isLoading: true)
			}
			web3Client.getNetworkFee().sink { completed in
				switch completed {
				case .finished:
					print("Received Fee")
				case let .failure(error):
					print(error.description)
					seal.reject(error)
				}
			} receiveValue: { gasInfo in
				self.ethGasFee = EthBaseFeeModel(baseFeeModel: gasInfo, isLoading: false)
				seal.fulfill(gasInfo)
			}.store(in: &cancellables)
		}
	}

	private func checkEthFee() -> Promise<EthGasInfoModel?> {
		Promise<EthGasInfoModel?> { seal in
			if let ethGasFee {
				seal.fulfill(ethGasFee.baseFeeModel)
			} else {
				getEthGasFee().done { ethGasInfo in
					seal.fulfill(ethGasInfo)
				}.catch { error in
					seal.reject(error)
				}
			}
		}
	}

	private func setupBindings() {
		checkInternetConnectivity { isConnected in
			if isConnected {
				self.fetchBalances()
			} else {
				self.showError(APIError.networkConnection)
			}
		}

		$manageAssetsList.sink { assets in
			guard var assets else { return }
			assets.sort { asset1, asset2 in
				asset1.holdAmountInDollor > asset2.holdAmountInDollor
			}
			let isPositionsSelected = ManageAssetPositionsViewModel.positionsSelected
			let selectedPositions = assets.filter { isPositionsSelected && $0.isPosition && !$0.holdAmount.isZero }
			let selectedAssets = assets.filter { !$0.isPosition && $0.isSelected }
			self.selectedManageAssetsList = selectedAssets + selectedPositions
		}.store(in: &cancellables)
	}

	private func showError(_ error: Error) {
		if let error = error as? APIError {
			#warning("Toast view is temporarily removed")
		}
	}
}

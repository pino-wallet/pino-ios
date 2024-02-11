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
	public var ethGasFee: EthBaseFeeModelDetails?
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

	public func fetchSharedInfo() -> Promise<Void> {
		print("== SENDING REQUEST ==")
		return firstly {
			self.getEthGasFee()
		}.then { gasFee in
			GlobalVariables.shared.ethGasFee = EthBaseFeeModelDetails(baseFeeModel: gasFee, isLoading: false)
			return self.getManageAssetLists()
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

	private func fetchSharedInfoPeriodically(completion: @escaping () -> Void) {
		Timer.publish(every: 11, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
				isNetConnected().sink { _ in
				} receiveValue: { isConnected in
					if isConnected {
						completion()
					} else {
						#warning("Toast view is temporarily removed")
					}
				}.store(in: &cancellables)
			}
			.store(in: &cancellables)
	}

	private func fetchBalances() {
		fetchSharedInfo().catch { error in
			#warning("Toast view is temporarily removed")
		}
	}

	private func calculateEthGasFee() {
		Timer.publish(every: 3, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
                if ethGasFee != nil {
                    GlobalVariables.shared.ethGasFee = EthBaseFeeModelDetails(baseFeeModel: ethGasFee!.baseFeeModel, isLoading: true)
                }
				getEthGasFee().done { ethGasFee in
					GlobalVariables.shared.ethGasFee = EthBaseFeeModelDetails(baseFeeModel: ethGasFee, isLoading: false)
				}.catch { error in
					print(error)
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
			web3Client.getNetworkFee().sink { completed in
				switch completed {
				case .finished:
					print("Received Fee")
				case let .failure(error):
					print(error)
					seal.reject(error)
				}
			} receiveValue: { gasInfo in
				seal.fulfill(gasInfo)
			}.store(in: &cancellables)
		}
	}

	private func setupBindings() {
		fetchSharedInfoPeriodically { [self] in
			fetchBalances()
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
}

// MARK: - GlobalVariales + Error

extension GlobalVariables {
	private enum GlobalErrors: LocalizedError {
		case connectionFailed
		case failedToFetchInfo

		var message: String {
			switch self {
			case .connectionFailed:
				return "No Internet Connection!"
			case .failedToFetchInfo:
				return "Failed to fetch info!"
			}
		}
	}
}

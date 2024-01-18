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
	public var ethGasFee: EthGasInfoModel!
	@Published
	public var manageAssetsList: [AssetViewModel]?
	@Published
	public var selectedManageAssetsList: [AssetViewModel]?
	@Published
	public var currentAccount: WalletAccount!

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
			getManageAssetLists()
		}.done { assets in
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
//						Toast.default(
//							title: GlobalErrors.connectionFailed.message,
//							subtitle: GlobalToastTitles.tryAgainToastTitle.message,
//							style: .error
//						)
//						.show(haptic: .warning)
					}
				}.store(in: &cancellables)
			}
			.store(in: &cancellables)
	}

	private func fetchBalances() {
		fetchSharedInfo().catch { error in
			#warning("Toast view is temporarily removed")
			//                Toast.default(
			//                    title: GlobalErrors.connectionFailed.message,
			//                    subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			//                    style: .error
			//                )
			//                .show(haptic: .warning)
		}
	}

	private func calculateEthGasFee() {
		Timer.publish(every: 3, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
				web3Client.getNetworkFee().sink { completed in
					switch completed {
					case .finished:
						print("Received Fee")
					case let .failure(error):
						print(error)
					}
				} receiveValue: { gasInfo in
					GlobalVariables.shared.ethGasFee = gasInfo
				}.store(in: &cancellables)
			}.store(in: &cancellables)
	}

	private func getManageAssetLists() -> Promise<[AssetViewModel]> {
		AssetManagerViewModel.shared.getAssetsList()
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

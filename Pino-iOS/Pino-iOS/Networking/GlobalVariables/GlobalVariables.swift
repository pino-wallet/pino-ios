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
	public var ethGasFee = (fee: BigNumber(number: "0", decimal: 0), feeInDollar: BigNumber(number: "0", decimal: 0))
	@Published
	public var manageAssetsList: [AssetViewModel]?
	@Published
	public var selectedManageAssetsList: [AssetViewModel] = []

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()
	private var internetConnectivity = InternetConnectivity()

	// MARK: - Private Initializer

	private init() {
		Timer.publish(every: 11, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
				print(seconds)
				isNetConnected().sink { _ in
				} receiveValue: { [self] isConnected in
					if isConnected {
						fetchSharedInfo()
					} else {}
				}.store(in: &cancellables)
			}
			.store(in: &cancellables)
	}

	public func fetchSharedInfo() -> Promise<Void> {
		print("SENDING REQUEST === ")
		return firstly {
			getManageAssetLists()
		}.get { assets in
			self.manageAssetsList = assets
			self.selectedManageAssetsList = self.manageAssetsList!.filter { $0.isSelected }
		}.done { assets in
			self.calculateEthGasFee(ethPrice: assets.first(where: { $0.isEth })!.price)
		}
	}

	// MARK: - Private Methods

	private func isNetConnected() -> AnyPublisher<Bool, Error> {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.eraseToAnyPublisher()
	}

	private func calculateEthGasFee(ethPrice: BigNumber) {
		_ = Web3Core.shared.calculateEthGasFee(ethPrice: ethPrice).done { fee, feeInDollar in
			GlobalVariables.shared.ethGasFee = (fee, feeInDollar)
		}.catch { error in
			print("//////// ERROR FETCHING ETH PRICE //////////")
		}
	}

	private func getManageAssetLists() -> Promise<[AssetViewModel]> {
		AssetManager.shared.getAssetsList()
	}
}

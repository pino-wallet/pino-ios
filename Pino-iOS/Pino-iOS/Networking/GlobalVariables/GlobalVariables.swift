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
        fetchSharedInfoPeriodically { [self] in
            fetchSharedInfo().catch { error in
                Toast.default(title: GlobalErrors.connectionFailed.message, subtitle: "Please try again!", style: .error)
                    .show(haptic: .warning)
            }
        }
        $manageAssetsList.sink { assets in
            guard let assets else { return }
            self.selectedManageAssetsList = assets.filter( { $0.isSelected } )
        }.store(in: &cancellables)
	}

	public func fetchSharedInfo() -> Promise<Void> {
		print("== SENDING REQUEST ==")
		return firstly {
			getManageAssetLists()
		}.get { assets in
			self.manageAssetsList = assets
		}.then { assets in
			self.calculateEthGasFee(ethPrice: assets.first(where: { $0.isEth })!.price)
		}
	}

	// MARK: - Private Methods

	private func isNetConnected() -> AnyPublisher<Bool, Error> {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.eraseToAnyPublisher()
	}
    
    private func fetchSharedInfoPeriodically(completion: @escaping ()-> Void) {
        Timer.publish(every: 11, on: .main, in: .common)
            .autoconnect()
            .sink { [self] seconds in
                isNetConnected().sink { _ in
                } receiveValue: { isConnected in
                    if isConnected {
                        completion()
                    } else {
                        Toast.default(title: GlobalErrors.connectionFailed.message, subtitle: "Please try again!", style: .error)
                            .show(haptic: .warning)
                    }
                }.store(in: &cancellables)
            }
            .store(in: &cancellables)
    }

	private func calculateEthGasFee(ethPrice: BigNumber) -> Promise<Void> {
		return Web3Core.shared.calculateEthGasFee(ethPrice: ethPrice).done { fee, feeInDollar in
			GlobalVariables.shared.ethGasFee = (fee, feeInDollar)
		}
	}

	private func getManageAssetLists() -> Promise<[AssetViewModel]> {
		AssetManagerViewModel.shared.getAssetsList()
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

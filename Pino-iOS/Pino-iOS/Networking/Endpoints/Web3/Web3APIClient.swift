//
//  Web3APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import Combine
import Foundation

final class Web3APIClient: Web3APIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<Web3Endpoint>()

	// MARK: - Public Methods

	public func getHashTypedData(eip712HashReqInfo: BodyParamsType)
		-> AnyPublisher<EIP712HashResponseModel, APIError> {
		networkManager.request(.hashTypeData(eip712ReqModel: eip712HashReqInfo))
	}

	public func getEnsAddress(ensName: String) -> AnyPublisher<EnsAddress, APIError> {
		let trimmedAdd = ensName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		return networkManager.request(.ensAddress(ensName: trimmedAdd))
	}

	#warning("Refactor this function later")
	public func getTokenPositionID(
		tokenAdd: String,
		positionType: IndexerPositionType,
		protocolName: String
	) -> AnyPublisher<PositionTokenModel, APIError> {
		networkManager.request(.positionID(tokenAdd: tokenAdd, positionType: positionType, protocolName: protocolName))
	}

	func getNetworkFee() -> AnyPublisher<EthGasInfoModel, APIError> {
		networkManager.request(.ehtGasInfo)
	}

	func getGasLimits() -> AnyPublisher<GasLimitsModel, APIError> {
		networkManager.request(.gasLimits)
	}
}

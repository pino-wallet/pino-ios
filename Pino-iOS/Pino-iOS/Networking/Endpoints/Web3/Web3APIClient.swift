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

	public func getHashTypedData(eip712HashReqInfo: EIP712HashRequestModel)
		-> AnyPublisher<EIP712HashResponseModel, APIError> {
		networkManager.request(.hashTypeData(eip712ReqModel: eip712HashReqInfo))
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
}

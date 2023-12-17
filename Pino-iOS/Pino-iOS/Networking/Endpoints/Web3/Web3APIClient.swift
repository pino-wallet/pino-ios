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

	#warning("Refactor this function later")
	public func getTokenPositionID(
		tokenAdd: String,
		positionType: IndexerPositionType,
		protocolName: String
	) -> AnyPublisher<PositionTokenModel, APIError> {
//		networkManager.request(.positionID(tokenAdd: tokenAdd, positionType: positionType, protocolName: protocolName))
		Just(PositionTokenModel(
			positionID: "0xb8c77482e45f1f44de1745f52c74426c631bdd52",
			tokenProtocol: "aave",
			underlyingToken: ""
		))
		.setFailureType(to: APIError.self)
		.eraseToAnyPublisher()
	}

	func getNetworkFee() -> AnyPublisher<EthGasInfoModel, APIError> {
		networkManager.request(.ehtGasInfo)
	}
}

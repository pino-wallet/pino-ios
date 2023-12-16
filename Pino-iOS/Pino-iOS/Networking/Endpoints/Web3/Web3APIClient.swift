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
			positionID: "0x4d5F47FA6A74757f35C14fD3a6Ef8E3C9BC514E8",
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

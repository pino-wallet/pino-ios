//
//  Web3APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import Foundation
import Combine

final class Web3APIClient: Web3APIService {
    
    // MARK: - Private Properties
    
    private let networkManager = NetworkManager<Web3Endpoint>()
    
    // MARK: - Public Methods
    
    public func getHashTypedData(eip712HashReqInfo: EIP712HashRequestModel) -> AnyPublisher<EIP712HashResponseModel, APIError> {
        networkManager.request(.hashTypeData(eip712ReqModel: eip712HashReqInfo))
    }
    
    
}

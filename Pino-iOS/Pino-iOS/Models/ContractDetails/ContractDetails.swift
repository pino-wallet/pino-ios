//
//  ContractDetails.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/8/23.
//

import Web3ContractABI

public struct ContractDetailsModel {
   // MARK: - Public Properties
	public let contract: DynamicContract
	public let solInvocation: SolidityInvocation
}

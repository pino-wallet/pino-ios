//
//  InvestW3ManagerProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/21/23.
//

import Combine
import Foundation
import PromiseKit

protocol InvestW3ManagerProtocol: Web3ManagerProtocol, AnyObject {
	var selectedToken: AssetViewModel { get }
	var selectedProtocol: InvestProtocolViewModel { get }
	var tokenPositionID: String! { get set }
	var web3Client: Web3APIClient { get }
	var cancellables: Set<AnyCancellable> { get set }

	func getTokenPositionID() -> Promise<String>
}

extension InvestW3ManagerProtocol {
	var web3Client: Web3APIClient {
		Web3APIClient()
	}

	public func getTokenPositionID() -> Promise<String> {
		Promise<String> { seal in
			self.tokenPositionID = "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643".lowercased()
			seal.fulfill(self.tokenPositionID)
//			web3Client.getTokenPositionID(
//				tokenAdd: selectedToken.id.lowercased(),
//				positionType: .investment,
//				protocolName: selectedProtocol.rawValue
//			).sink { completed in
//				switch completed {
//				case .finished:
//					print("Position id received successfully")
//				case let .failure(error):
//					print("Error getting position id:\(error)")
//					seal.reject(error)
//				}
//			} receiveValue: { tokenPositionModel in
//				self.tokenPositionID = tokenPositionModel.positionID.lowercased()
//				seal.fulfill(self.tokenPositionID)
//			}.store(in: &cancellables)
		}
	}
}

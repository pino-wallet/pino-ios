//
//  ActivityModelProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/1/23.
//

protocol ActivityModelProtocol: Codable {
	var txHash: String { get set }
	var type: String { get }
	var fromAddress: String { get }
	var toAddress: String { get }
	var failed: Bool? { get }
	var blockNumber: Int? { get }
	var blockTime: String { get }
	var gasUsed: String { get }
	var gasPrice: String { get set }
	var prev_txHash: String? { get set }
}

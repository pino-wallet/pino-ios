//
//  InvestManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 10/9/23.
//
import BigInt
import Foundation
import PromiseKit

class InvestManager {
	// MARK: - Private Properties

	private var web3 = Web3Core.shared
	private var investProtocol: InvestProtocolViewModel
	private var investAmount: String
	private var pinoWalletManager = PinoWalletManager()
	private var wethToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
	}

	init(investProtocol: InvestProtocolViewModel, investAmount: String) {
		self.investProtocol = investProtocol
		self.investAmount = investAmount
	}

	// MARK: Public Methods

	public func invest() {
		switch investProtocol {
		case .uniswap:
			break
		case .compound:
			break
		case .aave:
			break
		case .balancer:
			break
		case .maker:
			investInDai()
		}
	}

	// MARK: - Private Methods

	private func investInDai() {
//		        firstly {
//		            // Sign hash
//		        }.then { signiture -> Promise<(String, String?)> in
//		            // Check allowance of protocol
//		        }.then { signiture, allowanceData -> Promise<(String, String?)> in
//		            // Permit Transform
//		        }.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
		//                    self.web3.getDaiToSDaiCallData(
		//                        amount: investAmount.bigUInt!,
		//                        recipientAdd: pinoWalletManager.currentAccount.eip55Address
		//                    ).map { ($0, permitData, allowanceData) }
//		        }.then { protocolCallData, permitData, allowanceData in
//		            // MultiCall
//		            var callDatas = [permitData, protocolCallData]
//		            if let allowanceData { callDatas.insert(allowanceData, at: 0) }
//		            return self.callProxyMultiCall(data: callDatas, value: nil)
//		        }.done { trxHash in
//		            print(trxHash)
//		        }.catch { error in
//		            print(error.localizedDescription)
//		        }
	}

	private func withdrawDai() {
//		        firstly {
//		            // Sign hash
//		        }.then { signiture, allowanceData -> Promise<(String, String?)> in
//		            // Permit Transform
//		        }.then { [self] permitData -> Promise<(String, String)> in
		//                    self.web3.getSDaiToDaiCallData(
		//                        amount: investAmount.bigUInt!,
		//                        recipientAdd: pinoWalletManager.currentAccount.eip55Address
		//                    ).map { ($0, permitData, allowanceData) }
//		        }.then { protocolCallData, permitData in
//		            // MultiCall
//		            var callDatas = [permitData, protocolCallData]
//		            return self.callProxyMultiCall(data: callDatas, value: nil)
//		        }.done { trxHash in
//		            print(trxHash)
//		        }.catch { error in
//		            print(error.localizedDescription)
//		        }
	}

//	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<String> {
//		web3.callProxyMulticall(data: data, value: value ?? 0.bigNumber.bigUInt)
//	}
}

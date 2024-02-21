//
//  SendTransactionViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/4/23.
//

import Combine
import Foundation
import PromiseKit
import Web3

class SendTransactionViewModel {
	// MARK: Private Properties

	private let transaction: EthereumSignedTransaction
	private var txHash: String?
	private let web3Core = Web3Core.shared
	private let activityAPIClient = ActivityAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private var requestTimer: Timer?
	private var addPendingActivityClosure: (_ txHash: String) -> Void = { _ in }

	// MARK: Initializers

	init(transaction: EthereumSignedTransaction, addPendingActivityClosure: @escaping (_: String) -> Void) {
		self.transaction = transaction
		self.addPendingActivityClosure = addPendingActivityClosure
	}

	// MARK: Public Methods

	public func sendTx() -> Promise<SendTransactionStatus> {
		Promise<SendTransactionStatus> { seal in
			web3Core.callTransaction(trx: transaction).done { txHash in
				self.txHash = txHash
				self.addPendingActivityClosure(txHash)
				seal.fulfill(.pending)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getPendingTransactionActivity() -> Promise<SendTransactionStatus> {
		Promise<SendTransactionStatus> { seal in
			guard let txHash else {
				return
			}
			requestTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [self] timer in
				activityAPIClient.singleActivity(txHash: txHash).sink { completed in
					switch completed {
					case .finished:
						print("Transaction activity received sucsessfully")
					case let .failure(error):
						print(error)
					}
				} receiveValue: { activity in
					guard !ActivityHelper().iterateActivityModel(activity: activity)
                        .failed! != true else {
						seal.fulfill(.failed)
						self.destroyRequestTimer()
						return
					}
					seal.fulfill(.success)
					self.destroyRequestTimer()
				}.store(in: &cancellables)
			}
		}
	}

	public func destroyRequestTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}
}

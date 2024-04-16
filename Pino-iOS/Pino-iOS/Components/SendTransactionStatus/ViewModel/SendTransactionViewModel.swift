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

	public func getPendingTransactionActivity() -> Promise<Void> {
		Promise<Void> { seal in
			guard let txHash else { return }
			requestTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [self] timer in
				activityAPIClient.singleActivity(txHash: txHash).sink { completed in
					switch completed {
					case .finished:
						print("Transaction activity received sucsessfully")
					case let .failure(error):
						print("Error: getting transaction activity: \(error.description)")
					}
				} receiveValue: { activity in
					self.destroyRequestTimer()
					if let isActivityFailed = ActivityHelper().iterateActivityModel(activity: activity).failed, isActivityFailed {
						seal.reject(APIError.failedRequest)
					} else {
						seal.fulfill(())
					}
				}.store(in: &cancellables)
			}
		}
	}

	public func destroyRequestTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}
}

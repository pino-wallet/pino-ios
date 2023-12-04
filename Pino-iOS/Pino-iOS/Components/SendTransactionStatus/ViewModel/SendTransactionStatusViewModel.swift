//
//  SendTransactionStatusViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/20/23.
//

import Combine
import Foundation
import PromiseKit
import Web3

class SendTransactionStatusViewModel {
	// MARK: - Closures

	public var addPendingActivityClosure: (_ txHash: String) -> Void = { _ in }

	public let confirmingDescriptionText = "We'll notify you once confirmed."
	public let confirmingTitleText = "Confirming..."
	public let transactionSentText = "Successful"
	public let closeButtonText = "Close"
	public let viewStatusText = "View status"
	public let somethingWentWrongText = "Something went wrong!"
	public let tryAgainLaterText = "Please try again later"
	public let sentIconName = "sent"
	public let failedIconName = "failed_warning"
	public let viewStatusIconName = "primary_right_arrow"
	public let navigationDissmissIconName = "close"

	@Published
	public var sendTransactionStatus: SendTransactionStatus = .sending

	public var transactionSentInfoText: String {
		switch transactionInfo.transactionType {
		case .collateral:
			return "You collateralized \(Int(transactionInfo.transactionAmount)!.formattedWithCamma) \(transactionInfo.transactionToken.symbol) in \(transactionInfo.transactionDex.name)."
		case .withdraw:
			return "You withdrew  \(Int(transactionInfo.transactionAmount)!.formattedWithCamma) \(transactionInfo.transactionToken.symbol) from \(transactionInfo.transactionDex.name)."
		case .borrow:
			return "You borrowed  \(Int(transactionInfo.transactionAmount)!.formattedWithCamma) \(transactionInfo.transactionToken.symbol) from \(transactionInfo.transactionDex.name)."
		}
	}

	// MARK: - Private Properties

	private let transactions: [EthereumSignedTransaction]
	private let transactionInfo: TransactionInfoModel
	private let activityAPIClient = ActivityAPIClient()
	private let web3Core = Web3Core.shared
	private var txHash: String?
	private var requestTimer: Timer?
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(transactions: [EthereumSignedTransaction], transactionInfo: TransactionInfoModel) {
		self.transactions = transactions
		self.transactionInfo = transactionInfo

		sendTx()
	}

	// MARK: - Private Methods

	private func sendTx() {
		transactions.forEach { transaction in
			web3Core.callTransaction(trx: transaction).done { txHash in
				self.txHash = txHash
				self.setupRequestTimer()
				self.addPendingActivityClosure(txHash)
				self.sendTransactionStatus = .pending
			}.catch { _ in
				self.sendTransactionStatus = .failed
			}
		}
	}

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
			self.getPendingTransactionActivity()
		}
	}

	@objc
	private func getPendingTransactionActivity() {
		guard let txHash else {
			return
		}
		activityAPIClient.singleActivity(txHash: txHash).sink { completed in
			switch completed {
			case .finished:
				print("Transaction activity received sucsessfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { result in
			self.sendTransactionStatus = .success
			self.destroyRequestTimer()
		}.store(in: &cancellables)
	}

	// MARK: Public Methods

	public func destroyRequestTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}
}

class TransactionViewModel {
	private var txHash: String?
	private let transaction: EthereumSignedTransaction
	private let web3Core = Web3Core.shared
	private let activityAPIClient = ActivityAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private var requestTimer: Timer?
	public var addPendingActivityClosure: (_ txHash: String) -> Void = { _ in }

	init(transaction: EthereumSignedTransaction, addPendingActivityClosure: @escaping (_: String) -> Void) {
		self.transaction = transaction
		self.addPendingActivityClosure = addPendingActivityClosure
	}

	public func sendTx() -> Promise<SendTransactionStatus> {
		Promise<SendTransactionStatus> { seal in
			web3Core.callTransaction(trx: transaction).done { txHash in
				self.txHash = txHash
				self.addPendingActivityClosure(txHash)
				self.getPendingTransactionActivity()
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
				} receiveValue: { _ in
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

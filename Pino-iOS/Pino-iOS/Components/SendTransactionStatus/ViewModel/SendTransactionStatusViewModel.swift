//
//  SendTransactionStatusViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/20/23.
//

import Combine
import Foundation
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

	private let transaction: EthereumSignedTransaction
	private let transactionInfo: TransactionInfoModel
	private let activityAPIClient = ActivityAPIClient()
	private let web3Core = Web3Core.shared
	private var txHash: String?
	private var requestTimer: Timer?
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(transaction: EthereumSignedTransaction, transactionInfo: TransactionInfoModel) {
		self.transaction = transaction
		self.transactionInfo = transactionInfo

		sendTx()
	}

	// MARK: - Private Methods

	private func sendTx() {
		web3Core.callTransaction(trx: transaction).done { txHash in
			self.txHash = txHash
			self.setupRequestTimer()
			self.addPendingActivityClosure(txHash)
			self.sendTransactionStatus = .pending
		}.catch { _ in
			self.sendTransactionStatus = .failed
		}
	}

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 2,
			target: self,
			selector: #selector(getPendingTransactionActivity),
			userInfo: nil,
			repeats: true
		)
		requestTimer?.fire()
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
		} receiveValue: { _ in
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

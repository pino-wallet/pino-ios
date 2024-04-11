//
//  SendTransactionStatusViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/20/23.
//

import Foundation
import PromiseKit

class SendTransactionStatusViewModel {
	// MARK: - Closures

	public let confirmingDescriptionText = "This may take a short while"
	public let confirmingTitleText = "Confirming..."
	public let transactionSentText = "Successful"
	public let closeButtonText = "Close"
	public let viewStatusText = "View status"
	public let somethingWentWrongText = "Transaction failed"
	public let tryAgainLaterText = "Transaction was failed by the network."
	public let sentIconName = "sent"
	public let failedIconName = "transaction_failed"
	public let viewStatusIconName = "primary_right_arrow"
	public let navigationDissmissIconName = "close"

	@Published
	public var sendTransactionStatus: SendTransactionStatus = .sending

	public var transactionSentInfoText: String

	// MARK: - Private Properties

	private let transactions: [SendTransactionViewModel]

	// MARK: - Initializers

	init(transactions: [SendTransactionViewModel], transactionSentInfoText: String) {
		self.transactions = transactions
		self.transactionSentInfoText = transactionSentInfoText

		sendTx()
	}

	// MARK: - Private Methods

	private func sendTx() {
		var sendTXPromiss: [Promise<SendTransactionStatus>] = []
		transactions.forEach { transaction in
			sendTXPromiss.append(transaction.sendTx())
		}
		when(fulfilled: sendTXPromiss).done { transactionStatus in
			self.getPendingTransactionActivity()
			self.sendTransactionStatus = .pending
		}.catch { error in
			print("W3 Error: sending transaction: \(error)")
			self.sendTransactionStatus = .failed
		}
	}

	@objc
	private func getPendingTransactionActivity() {
		var getActivityPromiss: [Promise<Void>] = []
		transactions.forEach { transaction in
			getActivityPromiss.append(transaction.getPendingTransactionActivity())
		}
		when(fulfilled: getActivityPromiss).done {
			self.sendTransactionStatus = .success
		}.catch { error in
			print("W3 Error: getting pending activities: \(error)")
			self.sendTransactionStatus = .failed
		}
	}

	// MARK: Public Methods

	public func destroyRequestTimer() {
		transactions.forEach { transaction in
			transaction.destroyRequestTimer()
		}
	}
}

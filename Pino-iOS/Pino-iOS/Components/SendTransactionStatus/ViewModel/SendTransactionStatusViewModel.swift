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
		case .repay:
			return "You repaid  \(Int(transactionInfo.transactionAmount)!.formattedWithCamma) \(transactionInfo.transactionToken.symbol) to \(transactionInfo.transactionDex.name)."
		}
	}

	// MARK: - Private Properties

	private let transactions: [SendTransactionViewModel]
	private let transactionInfo: TransactionInfoModel

	// MARK: - Initializers

	init(transactions: [SendTransactionViewModel], transactionInfo: TransactionInfoModel) {
		self.transactions = transactions
		self.transactionInfo = transactionInfo

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
			self.sendTransactionStatus = .failed
		}
	}

	@objc
	private func getPendingTransactionActivity() {
		var getActivityPromiss: [Promise<SendTransactionStatus>] = []
		transactions.forEach { transaction in
			getActivityPromiss.append(transaction.getPendingTransactionActivity())
		}
		when(fulfilled: getActivityPromiss).done { transactionStatus in
			self.sendTransactionStatus = .success
		}.catch { _ in
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

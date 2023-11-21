//
//  SendTransactionStatusViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/20/23.
//

import Foundation
import Web3
import Combine

class SendTransactionStatusViewModel {
    // MARK: - Public Properties

    public let confirmingDescriptionText = "We'll notify you once confirmed."
    public let confirmingTitleText = "Confirming..."
    public let transactionSentText = "Successful"
    public let transactionSentInfoText = "mock"
    public let closeButtonText = "Close"
    public let viewStatusText = "View status"
    public let somethingWentWrongText = "Something went wrong!"
    public let tryAgainLaterText = "Please try again later"
    public let sentIconName = "sent"
    public let failedIconName = "failed_warning"
    public let viewStatusIconName = "primary_right_arrow"
    public let navigationDissmissIconName = "close"
    
    // MARK: - Private Properties
    private let transaction: EthereumSignedTransaction
    private let secondTransAction: EthereumSignedTransaction?
    private let activityAPIClient = ActivityAPIClient()
    private let web3Core = Web3Core.shared
    private var txHash: String?
    private var requestTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(transaction: EthereumSignedTransaction, secondTransaction: EthereumSignedTransaction? = nil) {
        self.transaction = transaction
        self.secondTransAction = secondTransaction
        
        sendTx()
    }
    
    
    // MARK: - Private Methods
    private func sendTx() {
        web3Core.callTransaction(trx: transaction).done { txHash in
            #warning("change page state to pending")
            self.txHash = txHash
            self.setupRequestTimer()
        }.catch { _ in
            #warning("change state page failed")
                    }
    }
    
    private func setupRequestTimer() {
        requestTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getPendingTransactionActivity), userInfo: nil, repeats: true)
        requestTimer?.fire()
    }
    
    @objc private func getPendingTransactionActivity() {
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
            #warning("change page state to success")
        }.store(in: &cancellables)
    }
    
    // MARK: Public Methods
    
    public func destroyRequestTimer() {
        requestTimer?.invalidate()
        requestTimer = nil
    }
    
}

//
//  WithdrawConfirmationViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import Combine
import Foundation
import PromiseKit
import Web3_Utility
import Web3ContractABI

class WithdrawConfirmationViewModel: InvestConfirmationProtocol {
	// MARK: - Private Properties

	private let web3 = Web3Core.shared
	private var cancellables = Set<AnyCancellable>()

	private lazy var withdrawManager: WithdrawManager = {
		WithdrawManager(
			contract: investProxyContract,
			selectedToken: selectedToken,
			withdrawProtocol: selectedProtocol,
			withdrawAmount: transactionAmount
		)
	}()

	// MARK: Internal Properties

	internal let transactionAmount: String
	internal let transactionAmountInDollar: String
	internal let selectedProtocol: InvestProtocolViewModel
	internal let selectedToken: AssetViewModel
	internal var gasFee: BigNumber!

	internal var investProxyContract: DynamicContract {
		switch selectedProtocol {
		case .uniswap, .balancer, .maker, .lido:
			return try! web3.getInvestProxyContract()
		case .compound:
			return try! web3.getCompoundProxyContract()
		case .aave:
			return try! web3.getPinoAaveProxyContract()
		}
	}

	// MARK: - Public Properties

	@Published
	public var formattedFeeInETH: String?
	@Published
	public var formattedFeeInDollar: String?

	public var formattedFeeInETHPublisher: Published<String?>.Publisher {
		$formattedFeeInETH
	}

	public var formattedFeeInDollarPublisher: Published<String?>.Publisher {
		$formattedFeeInDollar
	}

	// MARK: - Initializer

	init(
		selectedToken: AssetViewModel,
		selectedProtocol: InvestProtocolViewModel,
		withdrawAmount: String,
		withdrawAmountInDollar: String
	) {
		self.selectedToken = selectedToken
		self.selectedProtocol = selectedProtocol
		self.transactionAmount = withdrawAmount
		self.transactionAmountInDollar = withdrawAmountInDollar
	}

	// MARK: - Private Methods

	private func showError() {
		Toast.default(
			title: "Failed to fetch withdraw Info",
			subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			style: .error
		).show()
	}

	// MARK: - Public Methods

	public func getTransactionInfo() {
		guard let withdrawInfoPromiss = withdrawManager.getWithdrawInfo() else {
			showError()
			return
		}
		withdrawInfoPromiss.done { withdrawTrx, gasInfo in
			self.gasFee = gasInfo.fee
			self.formattedFeeInDollar = gasInfo.feeInDollar.priceFormat
			self.formattedFeeInETH = gasInfo.fee.sevenDigitFormat
		}.catch { error in
			self.showError()
		}
	}

	public func confirmTransaction(completion: @escaping () -> Void) {
		withdrawManager.confirmWithdraw { trx in
			print("INVEST TRX HASH: \(trx)")
			completion()
		}
	}
}

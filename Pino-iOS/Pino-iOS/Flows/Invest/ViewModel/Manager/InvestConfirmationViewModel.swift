//
//  InvestConfirmationViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import Combine
import Foundation
import PromiseKit
import Web3_Utility
import Web3ContractABI

class InvestConfirmationViewModel: InvestConfirmationProtocol {
	// MARK: - Private Properties

	private let web3 = Web3Core.shared
	private var cancellables = Set<AnyCancellable>()
	private let activityHelper = ActivityHelper()
	internal var investmentType: InvestmentType
	private lazy var investManager: DepositManager = {
		DepositManager(
			contract: investProxyContract,
			selectedToken: selectedToken,
			investProtocol: selectedProtocol,
			investAmount: transactionAmount
		)
	}()

	// MARK: - Internal Properties

	internal let transactionAmount: String
	internal let transactionAmountInDollar: String
	internal let selectedProtocol: InvestProtocolViewModel
	internal let selectedToken: AssetViewModel
	internal var gasFee: BigNumber!

	internal var investProxyContract: DynamicContract {
		switch selectedProtocol {
		case .maker, .lido:
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

	public var sendTransactions: [SendTransactionViewModel]? {
		switch selectedProtocol {
		case .maker, .lido:
			return getDepositTransaction()
		case .compound:
			return getCompoundTransactions()
		case .aave:
			return getAaveTransactions()
		}
	}

	// MARK: - Initializer

	init(
		selectedToken: AssetViewModel,
		selectedProtocol: InvestProtocolViewModel,
		investAmount: String,
		investAmountInDollar: String,
		investmentType: InvestmentType
	) {
		self.selectedToken = selectedToken
		self.selectedProtocol = selectedProtocol
		self.transactionAmount = investAmount
		self.transactionAmountInDollar = investAmountInDollar
		self.investmentType = investmentType
	}

	// MARK: - Private Methods

	private func showError() {
		Toast.default(
			title: "Failed to fetch deposit Info",
			subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			style: .error
		).show()
	}

	private func addPendingActivity(txHash: String, gasInfo: GasInfo) {
		let coreDataManager = CoreDataManager()
		var activityType: ActivityType {
			switch investmentType {
			case .create:
				return .create_investment
			case .increase:
				return .increase_investment
			}
		}
		let activityTokenModel = ActivityTokenModel(
			amount: Utilities.parseToBigUInt(transactionAmount, units: .custom(selectedToken.decimal))!.description,
			tokenID: selectedToken.id
		)
		let activityDetailModel = InvestmentActivityDetails(
			tokens: [activityTokenModel],
			poolId: "",
			activityProtocol: selectedProtocol.type,
			nftId: nil
		)
		let investActivityModel = ActivityInvestModel(
			txHash: txHash,
			type: activityType.rawValue,
			detail: activityDetailModel,
			fromAddress: "",
			toAddress: "",
			blockTime: activityHelper.getServerFormattedStringDate(date: Date()),
			gasUsed: gasInfo.increasedGasLimit!.description,
			gasPrice: gasInfo.maxFeePerGas.description
		)
		coreDataManager.addNewInvestActivity(
			activityModel: investActivityModel,
			accountAddress: investManager.walletManager.currentAccount.eip55Address
		)
		PendingActivitiesManager.shared.startActivityPendingRequests()
	}

	private func getDepositTransaction() -> [SendTransactionViewModel]? {
		guard let depositTrx = investManager.depositTrx else { return nil }
		let depositTransaction = SendTransactionViewModel(transaction: depositTrx) { pendingActivityTXHash in
			self.addPendingActivity(txHash: pendingActivityTXHash, gasInfo: self.investManager.depositGasInfo!)
		}
		return [depositTransaction]
	}

	private func getCompoundTransactions() -> [SendTransactionViewModel]? {
		guard let depositTrx = investManager.compoundManager.depositTrx else { return nil }
		let depositTransaction = SendTransactionViewModel(transaction: depositTrx) { [self] pendingActivityTXHash in
			addPendingActivity(txHash: pendingActivityTXHash, gasInfo: investManager.compoundManager.depositGasInfo!)
		}
		if let collateralCheckTrx = investManager.compoundManager.collateralCheckTrx {
			let collateralCheckTransaction =
				SendTransactionViewModel(transaction: collateralCheckTrx) { pendingActivityTXHash in
					#warning("Check enter/exit market ativity must be added or not")
				}
			return [depositTransaction, collateralCheckTransaction]
		} else {
			return [depositTransaction]
		}
	}

	private func getAaveTransactions() -> [SendTransactionViewModel]? {
		guard let depositTrx = investManager.aaveManager.depositTRX else { return nil }
		let depositTransaction = SendTransactionViewModel(transaction: depositTrx) { pendingActivityTXHash in
			self.addPendingActivity(
				txHash: pendingActivityTXHash,
				gasInfo: self.investManager.aaveManager.depositGasInfo!
			)
		}
		return [depositTransaction]
	}

	private func updateFee(gasInfos: [GasInfo]) {
		gasFee = gasInfos.map { $0.fee! }.reduce(0.bigNumber, +)
		formattedFeeInDollar = gasInfos.map { $0.feeInDollar! }.reduce(0.bigNumber, +).priceFormat
		formattedFeeInETH = gasInfos.map { $0.fee! }.reduce(0.bigNumber, +).sevenDigitFormat
	}

	// MARK: - Public Methods

	public func getTransactionInfo() {
		switch investmentType {
		case .create:
			investManager.getDepositInfo().done { gasInfos in
				self.updateFee(gasInfos: gasInfos)
			}.catch { error in
				self.showError()
			}
		case .increase:
			investManager.getIncreaseDepositInfo().done { gasInfos in
				self.updateFee(gasInfos: gasInfos)
			}.catch { error in
				self.showError()
			}
		}
	}
}

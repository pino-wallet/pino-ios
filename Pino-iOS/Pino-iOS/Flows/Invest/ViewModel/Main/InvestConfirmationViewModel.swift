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

class InvestConfirmationViewModel {
	// MARK: - Private Properties

	private let investAmount: String
	private let investAmountInDollar: String
	private let selectedProtocol: InvestProtocolViewModel
	private let selectedToken: AssetViewModel
	private var gasFee: BigNumber!

	private var cancellables = Set<AnyCancellable>()
	private var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

	// MARK: - Public Properties

	public let selectedProtocolTitle = "Protocol"
	public let feeTitle = "Fee"
	public let feeInfoActionSheetTitle = "Fee"
	public let feeInfoActionSheetDescription = "Sample Text"
	public let protocolInfoActionSheetTitle = "Protocl"
	public let protocolInfoActionSheetDescription = "Sample Text"
	public let feeErrorText = "Error in calculation!"
	public let feeErrorIcon = "refresh"
	public let confirmButtonTitle = "Confirm"
	public let insuffientButtonTitle = "Insufficient Amount"

	public var isTokenVerified: Bool {
		selectedToken.isVerified
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var customAssetImage: String {
		selectedToken.customAssetImage
	}

	public var formattedInvestAmount: String {
		investAmount.tokenFormatting(token: selectedToken.symbol)
	}

	public var formattedInvestAmountInDollar: String {
		investAmountInDollar
	}

	public var selectedProtocolImage: String {
		selectedProtocol.protocolInfo.image
	}

	public var selectedProtocolName: String {
		selectedProtocol.protocolInfo.name
	}

	@Published
	public var formattedFeeInETH: String?

	@Published
	public var formattedFeeInDollar: String?

	public var userBalanceIsEnough: Bool {
		if gasFee > ethToken.holdAmount {
			return false
		} else {
			return true
		}
	}

	// MARK: - Initializer

	init(
		selectedToken: AssetViewModel,
		selectedProtocol: InvestProtocolViewModel,
		investAmount: String,
		investAmountInDollar: String
	) {
		self.selectedToken = selectedToken
		self.selectedProtocol = selectedProtocol
		self.investAmount = investAmount
		self.investAmountInDollar = investAmountInDollar
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupBindings() {
		GlobalVariables.shared.$ethGasFee.sink { fee, feeInDollar in
			self.gasFee = fee
			self.formattedFeeInETH = fee.sevenDigitFormat.ethFormatting
			self.formattedFeeInDollar = feeInDollar.priceFormat
		}.store(in: &cancellables)
	}
}

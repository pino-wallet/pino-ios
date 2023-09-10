//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import Combine
import PromiseKit
import Web3
import Web3_Utility

struct ApproveContractViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Asset approval"
	public let titleImageName = "approve_warning"
	public let learnMoreButtonTitle = "Learn more"
	public let approveText = "Approve permit 2 to access your"
	public let approveDescriptionText = "This will only happen one time."
	public let approveButtonTitle = "Approve"
	public let rightArrowImageName = "primary_right_arrow"
	public let learnMoreURL = "https://www.google.com"

	// MARK: - Private Properties

	private var web3 = Web3Core.shared
	private var swapConfirmVM: SwapConfirmationViewModel!

	private var destTokenID: String {
		swapConfirmVM.toToken.selectedToken.id
	}

	private var destTokenAmount: BigNumber {
		let destAmount = Utilities.parseToBigUInt(
			swapConfirmVM.toToken.tokenAmount!,
			decimals: swapConfirmVM.toToken.selectedToken.decimal
		)!
		return BigNumber(unSignedNumber: destAmount, decimal: swapConfirmVM.toToken.selectedToken.decimal)
	}

	// MARK: - Initializers

	public init(swapConfirmVM: SwapConfirmationViewModel) {
		self.swapConfirmVM = swapConfirmVM
	}

	// MARK: - Public Methods

	public func approveTokenUsageToPermit(completion: @escaping () -> Void) {
		web3.approveContract(
			address: destTokenID,
			amount: destTokenAmount.bigUInt,
			spender: Web3Core.Constants.permitAddress
		)
		.done { trxHash in
			print("APPROVE TRX HASH: \(trxHash)")
			completion()
		}.catch { error in
			print("Failed to give permission")
			Toast.default(title: "Failed to Approve", style: .error).show(haptic: .warning)
		}
	}
}

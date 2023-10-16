//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility

class ApproveContractViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Asset approval"
	public let learnMoreButtonTitle = "Why is this required?"
	public let allowText = "Allow"
	public let approveMidText = "to be used for"
	public let approveDescriptionText = "You will only do it once."
	public let approveButtonTitle = "Approve"
	public let rightArrowImageName = "primary_right_arrow"
	public let dismissButtonName = "dissmiss"
	#warning("this is mock url")
	public let learnMoreURL = "https://www.google.com"
	public let pleaseWaitTitleText = "Please wait"
	public let insufficientBalanceTitleText = "Insufficient balance"
	public let failedToApproveErrorText = "Failed to Approve"
	public let failedToGetApproveFeeText = "Failed to get approve fee"
	public let failedToGetApproveDetailsText = "Failed to get approve details, please try again"

	public enum ApproveStatuses {
		case calculatingFee
		case insufficientEthBalance
		case normal
		case loading
	}

	@Published
	public var approveStatus: ApproveStatuses = .calculatingFee

	public var tokenSymbol: String {
		approveAssetVM.symbol
	}

	public var tokenImage: URL {
		approveAssetVM.image
	}

	// MARK: - Private Properties

	private let globalAssetsList = GlobalVariables.shared.manageAssetsList
	private var approveAssetVM: AssetViewModel {
		(globalAssetsList?.first(where: { $0.id == contractId }))!
	}

	private var web3 = Web3Core.shared
	private var swapConfirmVM: SwapConfirmationViewModel!
	private var approveContractDetails: ContractDetailsModel?
	private var approveGasInfo: GasInfo?

	private var contractId: String

	// MARK: - Initializers

	public init(contractId: String) {
		self.contractId = contractId

		getApproveDetails()
	}

	// MARK: - Public Methods

	public func approveTokenUsageToPermit(completion: @escaping (_ approveTxHash: String) -> Void) {
		guard let approveContractDetails else {
			return
		}
		approveStatus = .loading

		web3.approveContract(contractDetails: approveContractDetails).done { trxHash in
			print("APPROVE TRX HASH: \(trxHash)")
			completion(trxHash)
		}.catch { error in
			print("Failed to give permission")
			Toast.default(title: self.failedToApproveErrorText, style: .error).show(haptic: .warning)
		}
	}

	public func getApproveDetails() {
		approveStatus = .calculatingFee
		web3.getApproveContractDetails(
			address: contractId,
			amount: BigNumber.maxUInt256.bigUInt,
			spender: Web3Core.Constants.permitAddress
		)
		.done { contractDetails in
			self.approveContractDetails = contractDetails
			self.web3.getApproveGasInfo(contractDetails: contractDetails).done { gasInfo in
				self.approveGasInfo = gasInfo
				guard let userEthToken = self.globalAssetsList?.first(where: { $0.isEth }) else {
					return
				}
				if gasInfo.fee > userEthToken.holdAmount {
					self.approveStatus = .insufficientEthBalance
				} else {
					self.approveStatus = .normal
				}
			}.catch { error in
				print("Failed to get approve gas info")
				Toast.default(title: self.failedToGetApproveFeeText, style: .error).show(haptic: .warning)
			}
		}.catch { error in
			print("Failed to get approve transaction")
			Toast.default(title: self.failedToGetApproveDetailsText, style: .error).show(haptic: .warning)
		}
	}
}

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
	public let unverifiedTAssetImageName = "unverified_asset"

	public enum ApproveStatuses {
		case calculatingFee
		case insufficientEthBalance
		case normal
	}

	@Published
	public var approveStatus: ApproveStatuses = .calculatingFee

	public var tokenSymbol: String {
		approveAssetVM.symbol
	}

	public var tokenImage: URL? {
		if !approveAssetVM.isVerified {
			return nil
		} else {
			return approveAssetVM.image
		}
	}

	public var approveGasInfo: GasInfo?

	public var approveAssetVM: AssetViewModel {
		(globalAssetsList?.first(where: { $0.id == contractId }))!
	}

	// MARK: - Private Properties

	private let globalAssetsList = GlobalVariables.shared.manageAssetsList

	private var web3 = Web3Core.shared
	private var swapConfirmVM: SwapConfirmationViewModel!
	private var approveContractDetails: ContractDetailsModel?

	private var contractId: String

	// MARK: - Initializers

	public init(contractId: String) {
		self.contractId = contractId

		getApproveDetails()
	}

	// MARK: - Public Methods

	public func goToApproveLoading(completion: @escaping (_ approveTxHash: ContractDetailsModel) -> Void) {
		guard let approveContractDetails else {
			return
		}
		completion(approveContractDetails)
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
				if gasInfo.fee! > userEthToken.holdAmount {
					self.approveStatus = .insufficientEthBalance
				} else {
					self.approveStatus = .normal
				}
			}.catch { error in
				print("Error: getting approve gas info: \(error)")
				Toast.default(title: self.failedToGetApproveFeeText, style: .error).show(haptic: .warning)
			}
		}.catch { error in
			print("Error: getting approve transaction: \(error)")
			Toast.default(title: self.failedToGetApproveDetailsText, style: .error).show(haptic: .warning)
		}
	}
}

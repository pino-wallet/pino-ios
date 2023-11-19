//
//  PendingActivitiesManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//

import Combine
import Foundation

class PendingActivitiesManager {
	// MARK: - Public Shared Accessor

	public static let shared = PendingActivitiesManager()

	// MARK: - Public Properties

	@Published
	public var pendingActivitiesList: [ActivityModelProtocol] = []

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let activityHelper = ActivityHelper()
	private let coreDataManager = CoreDataManager()
	private let requestsDispatchGroup = DispatchGroup()
	private let walletManager = PinoWalletManager()
	private var requestsTimer: Cancellable?
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

	public func startActivityPendingRequests() {
		getPendingActivitiesFromCoreData()
		stopActivityPendingRequests()
		getActivityPendings()
		requestsTimer = Timer.publish(every: 300, on: .main, in: .common).autoconnect().sink { _ in
			self.getActivityPendings()
		}
	}

	public func stopActivityPendingRequests() {
		requestsTimer?.cancel()
		requestsTimer = nil
	}

	// MARK: - Private Methods

	private func getPendingActivitiesFromCoreData() {
		pendingActivitiesList = []
		for activity in coreDataManager.getAllActivities() {
			if activity.accountAddress == walletManager.currentAccount.eip55Address {
				switch ActivityType(rawValue: activity.type) {
				case .swap:
					let cdSwapActivity = activity as! CDSwapActivity
					pendingActivitiesList.append(ActivitySwapModel(
						txHash: cdSwapActivity.txHash,
						type: cdSwapActivity.type,
						detail: SwapActivityDetails(
							fromToken: ActivityTokenModel(
								amount: cdSwapActivity.details.from_token.amount,
								tokenID: cdSwapActivity.details.from_token.tokenId
							),
							toToken: ActivityTokenModel(
								amount: cdSwapActivity.details.to_token.amount,
								tokenID: cdSwapActivity.details.to_token.tokenId
							),
							activityProtocol: cdSwapActivity.details.activityProtool
						),
						fromAddress: cdSwapActivity.fromAddress,
						toAddress: cdSwapActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdSwapActivity.blockTime,
						gasUsed: cdSwapActivity.gasUsed,
						gasPrice: cdSwapActivity.gasPrice,
						prev_txHash: cdSwapActivity.prevTxHash
					))
				case .transfer:
					let cdTransferActivity = activity as! CDTransferActivity
					pendingActivitiesList.append(ActivityTransferModel(
						txHash: cdTransferActivity.txHash,
						type: cdTransferActivity.type,
						detail: TransferActivityDetail(
							amount: cdTransferActivity.details.amount,
							tokenID: cdTransferActivity.details.tokenID,
							from: cdTransferActivity.details.from,
							to: cdTransferActivity.details.to
						),
						fromAddress: cdTransferActivity.fromAddress,
						toAddress: cdTransferActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdTransferActivity.blockTime,
						gasUsed: cdTransferActivity.gasUsed,
						gasPrice: cdTransferActivity.gasPrice,
						prev_txHash: cdTransferActivity.prevTxHash
					))
				case .transfer_from:
					let cdTransferActivity = activity as! CDTransferActivity
					pendingActivitiesList.append(ActivityTransferModel(
						txHash: cdTransferActivity.txHash,
						type: cdTransferActivity.type,
						detail: TransferActivityDetail(
							amount: cdTransferActivity.details.amount,
							tokenID: cdTransferActivity.details.tokenID,
							from: cdTransferActivity.details.from,
							to: cdTransferActivity.details.to
						),
						fromAddress: cdTransferActivity.fromAddress,
						toAddress: cdTransferActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdTransferActivity.blockTime,
						gasUsed: cdTransferActivity.gasUsed,
						gasPrice: cdTransferActivity.gasPrice,
						prev_txHash: cdTransferActivity.prevTxHash
					))
				case .approve:
					let cdApproveActivity = activity as! CDApproveActivity
					pendingActivitiesList.append(ActivityApproveModel(
						txHash: cdApproveActivity.txHash,
						type: cdApproveActivity.type,
						detail: ApproveActivityDetail(
							amount: cdApproveActivity.details.amount,
							owner: cdApproveActivity.details.owner,
							spender: cdApproveActivity.details.spender,
							tokenID: cdApproveActivity.details.tokenID
						),
						fromAddress: cdApproveActivity.fromAddress,
						toAddress: cdApproveActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdApproveActivity.blockTime,
						gasUsed: cdApproveActivity.gasUsed,
						gasPrice: cdApproveActivity.gasPrice,
						prev_txHash: cdApproveActivity.prevTxHash
					))
				case .create_investment, .increase_investment:
					let cdInvestActivity = activity as! CDInvestActivity
					pendingActivitiesList.append(ActivityInvestModel(
						txHash: cdInvestActivity.txHash,
						type: cdInvestActivity.type,
						detail: InvestmentActivityDetails(
							tokens: cdInvestActivity.details.tokens.compactMap {
								ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
							},
							poolId: cdInvestActivity.details.poolID,
							activityProtocol: cdInvestActivity.details.activityProtocol,
							nftId: convertOptionalStringToInt(string: cdInvestActivity.details.nftID)
						),
						fromAddress: cdInvestActivity.fromAddress,
						toAddress: cdInvestActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdInvestActivity.blockTime,
						gasUsed: cdInvestActivity.gasUsed,
						gasPrice: cdInvestActivity.gasPrice,
						prev_txHash: cdInvestActivity.prevTxHash
					))
				case .decrease_investment, .withdraw_investment:
					let cdWithdrawActivity = activity as! CDWithdrawActivity
					pendingActivitiesList.append(ActivityWithdrawModel(
						txHash: cdWithdrawActivity.txHash,
						type: cdWithdrawActivity.type,
						detail: InvestmentActivityDetails(
							tokens: cdWithdrawActivity.details.tokens.compactMap {
								ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
							},
							poolId: cdWithdrawActivity.details.poolID,
							activityProtocol: cdWithdrawActivity.details.activityProtocol,
							nftId: convertOptionalStringToInt(string: cdWithdrawActivity.details.nftID)
						),
						fromAddress: cdWithdrawActivity.fromAddress,
						toAddress: cdWithdrawActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdWithdrawActivity.blockTime,
						gasUsed: cdWithdrawActivity.gasUsed,
						gasPrice: cdWithdrawActivity.gasPrice,
						prev_txHash: cdWithdrawActivity.prevTxHash
					))
				case .borrow:
					let cdBorrowActivity = activity as! CDBorrowActivity
					pendingActivitiesList.append(ActivityBorrowModel(
						txHash: cdBorrowActivity.txHash,
						type: cdBorrowActivity.type,
						detail: BorrowActivityDetails(
							activityProtocol: cdBorrowActivity.details.activityProtocol,
							token: ActivityTokenModel(
								amount: cdBorrowActivity.details.token.amount,
								tokenID: cdBorrowActivity.details.token.tokenId
							)
						),
						fromAddress: cdBorrowActivity.fromAddress,
						toAddress: cdBorrowActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdBorrowActivity.blockTime,
						gasUsed: cdBorrowActivity.gasUsed,
						gasPrice: cdBorrowActivity.gasPrice,
						prev_txHash: cdBorrowActivity.prevTxHash
					))
				case .repay:
					let cdRepayActivity = activity as! CDRepayActivity
					pendingActivitiesList.append(ActivityRepayModel(
						txHash: cdRepayActivity.txHash,
						type: cdRepayActivity.type,
						detail: RepayActivityDetails(
							activityProtocol: cdRepayActivity.details.activityProtocol,
							repaidToken: ActivityTokenModel(
								amount: cdRepayActivity.details.repaid_token.amount,
								tokenID: cdRepayActivity.details.repaid_token.tokenId
							),
							repaidWithToken: ActivityTokenModel(
								amount: cdRepayActivity.details.repaid_with_token.amount,
								tokenID: cdRepayActivity.details.repaid_with_token.tokenId
							)
						),
						fromAddress: cdRepayActivity.fromAddress,
						toAddress: cdRepayActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdRepayActivity.blockTime,
						gasUsed: cdRepayActivity.gasUsed,
						gasPrice: cdRepayActivity.gasPrice,
						prev_txHash: cdRepayActivity.prevTxHash
					))
				case .increase_collateral, .decrease_collateral, .create_collateral, .remove_collateral,
				     .enable_collateral,
				     .disable_collateral:
					let cdCollateralActivity = activity as! CDCollateralActivity
					pendingActivitiesList.append(ActivityCollateralModel(
						txHash: cdCollateralActivity.txHash,
						type: cdCollateralActivity.type,
						detail: CollateralActivityDetails(
							activityProtocol: cdCollateralActivity.details.activityProtocol,
							tokens: cdCollateralActivity.details.tokens.compactMap {
								ActivityTokenModel(amount: $0.amount, tokenID: $0.tokenId)
							}
						),
						fromAddress: cdCollateralActivity.fromAddress,
						toAddress: cdCollateralActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdCollateralActivity.blockTime,
						gasUsed: cdCollateralActivity.gasUsed,
						gasPrice: cdCollateralActivity.gasPrice,
						prev_txHash: cdCollateralActivity.prevTxHash
					))
				default:
					print("unknown activity type")
				}
			}
		}
	}

	private func convertOptionalStringToInt(string: String?) -> Int? {
		guard let string else {
			return nil
		}
		return Int(string)
	}

	private func getActivityPendings() {
		for pendingActivity in pendingActivitiesList {
			requestsDispatchGroup.enter()
			activityAPIClient.singleActivity(txHash: pendingActivity.txHash).sink { completed in
				switch completed {
				case .finished:
					print("Activity received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { activity in
				let iteratedActivity = self.activityHelper.iterateActivityModel(activity: activity)
				if iteratedActivity != nil {
					self.pendingActivitiesList.removeAll(where: { $0.txHash == iteratedActivity!.txHash })
					self.coreDataManager.deleteActivityByID(iteratedActivity!.txHash)
					if self.pendingActivitiesList.isEmpty {
						self.stopActivityPendingRequests()
					}
				}
				self.requestsDispatchGroup.leave()
			}.store(in: &cancellables)
		}
	}
}

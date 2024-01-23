//
//  ActivitySeparatorWithTime.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/3/23.
//

import Foundation

struct ActivityHelper {
	// MARK: - TypeAliases

	public typealias SeparatedActivitiesType = [(title: String, activities: [ActivityCellViewModel])]
	public typealias SeparatedActivitiesWithDayType = [Int: [ActivityCellViewModel]]
	public typealias ActivitiesInfoType = (
		indexPaths: [IndexPath],
		sections: [IndexSet],
		finalSeparatedActivities: SeparatedActivitiesType
	)

	// MARK: - Public Properties

	public var globalAssetsList: [AssetViewModel]?

	// MARK: - Public Methods

	public func iterateActivityModel(activity: ResultActivityModel) -> ActivityModelProtocol? {
		switch activity {
		case let .swap(swapActivity):
			return swapActivity
		case let .transfer(transferActivity):
			return transferActivity
		case let .transfer_from(transferActivity):
			return transferActivity
		case let .borrow(borrowActivity):
			return borrowActivity
		case let .repay(repayActvity):
			return repayActvity
		case let .withdraw(withdrawActivity):
			return withdrawActivity
		case let .invest(investActivity):
			return investActivity
		case let .collateral(collateralActivity):
			return collateralActivity
		case let .approve(approveActivity):
			return approveActivity
		case .unknown:
			return nil
		}
	}

	public func iterateActivitiesFromResponse(activities: ActivitiesModel) -> [ActivityModelProtocol] {
		var iteratedActivities: [ActivityModelProtocol] = []
		for activity in activities {
			if let iteratedActivity = iterateActivityModel(activity: activity) {
				iteratedActivities.append(iteratedActivity)
			}
		}
		return iteratedActivities
	}

	public func getActivityDate(activityBlockTime: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		return dateFormatter.date(from: activityBlockTime)!
	}

	public func getServerFormattedStringDate(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		return dateFormatter.string(from: date)
	}

	public func separateActivitiesByTime(activities: [ActivityCellViewModel]) -> SeparatedActivitiesType {
		var separatedActivitiesWithDay: SeparatedActivitiesWithDayType

		separatedActivitiesWithDay = separateActivitiesByDay(activities: activities)

		return sortSeparatedActivities(separatedActivitiesWithDay: separatedActivitiesWithDay)
	}

	public func getNewActivitiesInfo(
		separatedActivities: SeparatedActivitiesType,
		newSeparatedActivities: SeparatedActivitiesType
	) -> ActivitiesInfoType {
		var indexPaths = [IndexPath]()
		var indexSets: [IndexSet] = []
		var finalSeparatedActivities: SeparatedActivitiesType = separatedActivities

		for newSeparatedActivity in newSeparatedActivities {
			let foundSectionIndex = finalSeparatedActivities.firstIndex { $0.title == newSeparatedActivity.title }
			if foundSectionIndex != nil {
				finalSeparatedActivities[foundSectionIndex!].activities
					.append(contentsOf: newSeparatedActivity.activities)
				finalSeparatedActivities[foundSectionIndex!].activities = finalSeparatedActivities[foundSectionIndex!]
					.activities
					.sorted(by: {
						getActivityDate(activityBlockTime: $0.blockTime)
							.timeIntervalSince1970 > getActivityDate(activityBlockTime: $1.blockTime).timeIntervalSince1970
					})
				for (index, item) in finalSeparatedActivities[foundSectionIndex!].activities.enumerated() {
					if newSeparatedActivity.activities
						.contains(where: { item.defaultActivityModel.txHash == $0.defaultActivityModel.txHash }) {
						indexPaths.append(IndexPath(row: index, section: foundSectionIndex!))
					}
				}
			} else {
				finalSeparatedActivities.append(newSeparatedActivity)
				finalSeparatedActivities = finalSeparatedActivities
					.sorted(by: {
						getActivityDate(activityBlockTime: $0.activities[0].blockTime)
							.timeIntervalSince1970 > getActivityDate(activityBlockTime: $1.activities[0].blockTime)
							.timeIntervalSince1970
					})
				let foundSectionIndex = finalSeparatedActivities
					.firstIndex(where: { $0.title == newSeparatedActivity.title })
				finalSeparatedActivities[foundSectionIndex!].activities = finalSeparatedActivities[foundSectionIndex!]
					.activities
					.sorted(by: {
						getActivityDate(activityBlockTime: $0.blockTime)
							.timeIntervalSince1970 > getActivityDate(activityBlockTime: $1.blockTime).timeIntervalSince1970
					})
				indexSets.append(IndexSet(integer: foundSectionIndex!))
				for _ in finalSeparatedActivities[foundSectionIndex!].activities {
					indexPaths
						.append(IndexPath(
							row: finalSeparatedActivities[foundSectionIndex!].activities.count - 1,
							section: foundSectionIndex!
						))
				}
			}
		}

		return (indexPaths: indexPaths, sections: indexSets, finalSeparatedActivities: finalSeparatedActivities)
	}

	public func getReplacedActivitiesInfo(
		replacedActivities: [ActivityCellViewModel],
		separatedActivities: SeparatedActivitiesType
	) -> (indexPaths: [IndexPath], finalSeparatedActivities: SeparatedActivitiesType) {
		var indexPaths: [IndexPath] = []
		var finalSeparatedActivities = separatedActivities

		for (index, separatedActivity) in finalSeparatedActivities.enumerated() {
			for replacedActivity in replacedActivities {
				let foundReplacingIndex = separatedActivity.activities
					.firstIndex(where: { $0.defaultActivityModel.txHash == replacedActivity.defaultActivityModel.txHash })
				let foundReplactingIndexWithPrevTxHash = separatedActivity.activities
					.firstIndex(where: {
						$0.defaultActivityModel.txHash == replacedActivity.defaultActivityModel.prev_txHash
					})
				if foundReplacingIndex != nil {
					finalSeparatedActivities[index].activities[foundReplacingIndex!] = replacedActivity
					indexPaths.append(IndexPath(item: foundReplacingIndex!, section: index))
				} else if foundReplactingIndexWithPrevTxHash != nil {
					finalSeparatedActivities[index].activities[foundReplactingIndexWithPrevTxHash!] = replacedActivity
					indexPaths.append(IndexPath(item: foundReplactingIndexWithPrevTxHash!, section: index))
				} else {
					print("no replacing activities there")
				}
			}
		}
		return (indexPaths: indexPaths, finalSeparatedActivities: finalSeparatedActivities)
	}

	public func findTokenInGlobalAssetsList(tokenId: String) -> AssetViewModel? {
		guard let globalAssetsList else {
			fatalError("Manage assets list is nil")
		}
		return globalAssetsList.first(where: { $0.id.lowercased() == tokenId.lowercased() })
	}

	// MARK: - Private Methods

	private func getActivityDetails(activity: ActivityCellViewModel) -> ActivityCellViewModel? {
		var resultActivity = activity
		let activityDefaultModel = activity.defaultActivityModel
		switch activity.activityType {
		case .transfer:
			guard let transferActivityModel = activityDefaultModel as? ActivityTransferModel,
			      let transferToken = findTokenInGlobalAssetsList(tokenId: transferActivityModel.detail.tokenID) else {
				return nil
			}
			resultActivity.transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: transferActivityModel,
				token: transferToken
			)
			return resultActivity
		case .transfer_from:
			guard let transferActivityModel = activityDefaultModel as? ActivityTransferModel,
			      let transferToken = findTokenInGlobalAssetsList(tokenId: transferActivityModel.detail.tokenID) else {
				return nil
			}
			resultActivity.transferDetailsVM = TransferActivityDetailsViewModel(
				activityModel: transferActivityModel,
				token: transferToken
			)
			return resultActivity
		case .swap:
			guard let swapActivityModel = activityDefaultModel as? ActivitySwapModel,
			      let fromToken = findTokenInGlobalAssetsList(tokenId: swapActivityModel.detail.fromToken.tokenID),
			      let toToken = findTokenInGlobalAssetsList(tokenId: swapActivityModel.detail.toToken.tokenID) else {
				return nil
			}
			resultActivity.swapDetailsVM = SwapActivityDetailsViewModel(
				activityModel: swapActivityModel,
				fromToken: fromToken,
				toToken: toToken
			)
			return resultActivity
		case .borrow:
			guard let borrowActivityModel = activityDefaultModel as? ActivityBorrowModel,
			      let borrowToken = findTokenInGlobalAssetsList(tokenId: borrowActivityModel.detail.token.tokenID)
			else {
				return nil
			}
			resultActivity.borrowDetailsVM = BorrowActivityDetailsViewModel(
				activityModel: borrowActivityModel,
				token: borrowToken
			)
			return resultActivity
		case .repay, .repay_behalf:
			guard let repayActivityModel = activityDefaultModel as? ActivityRepayModel,
			      let repayToken = findTokenInGlobalAssetsList(tokenId: repayActivityModel.detail.repaidToken.tokenID)
			else {
				return nil
			}
			resultActivity.repayDetailsVM = RepayActivityDetailsViewModel(
				activityModel: repayActivityModel,
				token: repayToken
			)
			return resultActivity
		case .decrease_investment, .withdraw_investment:
			guard let withdrawActivityModel = activityDefaultModel as? ActivityWithdrawModel,
			      let withdrawToken = findTokenInGlobalAssetsList(
			      	tokenId: withdrawActivityModel.detail.tokens[0]
			      		.tokenID
			      ) else {
				return nil
			}
			resultActivity.withdrawInvestmentDetailsVM = WithdrawInvestmentActivityDetailsViewModel(
				activityModel: withdrawActivityModel,
				token: withdrawToken
			)
			return resultActivity
		case .create_investment, .increase_investment:
			guard let investActivityModel = activityDefaultModel as? ActivityInvestModel,
			      let investToken = findTokenInGlobalAssetsList(tokenId: investActivityModel.detail.tokens[0].tokenID)
			else {
				return nil
			}
			resultActivity.investDetailsVM = InvestActivityDetailsViewModel(
				activityModel: investActivityModel,
				token: investToken
			)
			return resultActivity
		case .create_withdraw_investment:
			if resultActivity.isWithdrawTransaction {
				guard let withdrawActivityModel = activityDefaultModel as? ActivityWithdrawModel,
				      let withdrawToken = findTokenInGlobalAssetsList(
				      	tokenId: withdrawActivityModel.detail.tokens[0]
				      		.tokenID
				      ) else {
					return nil
				}
				resultActivity.withdrawInvestmentDetailsVM = WithdrawInvestmentActivityDetailsViewModel(
					activityModel: withdrawActivityModel,
					token: withdrawToken
				)
				return resultActivity
			} else {
				guard let investActivityModel = activityDefaultModel as? ActivityInvestModel,
				      let investToken = findTokenInGlobalAssetsList(
				      	tokenId: investActivityModel.detail.tokens[0]
				      		.tokenID
				      ) else {
					return nil
				}
				resultActivity.investDetailsVM = InvestActivityDetailsViewModel(
					activityModel: investActivityModel,
					token: investToken
				)
				return resultActivity
			}
		case .create_collateral, .increase_collateral:
			guard let collateralActivityModel = activityDefaultModel as? ActivityCollateralModel,
			      let collateralToken = findTokenInGlobalAssetsList(
			      	tokenId: collateralActivityModel.detail.tokens[0]
			      		.tokenID
			      ) else {
				return nil
			}
			resultActivity.collateralDetailsVM = CollateralActivityDetailsViewModel(
				activityModel: collateralActivityModel,
				token: collateralToken
			)
			return resultActivity
		case .remove_collateral, .decrease_collateral:
			guard let withdrawCollateralActivityModel = activityDefaultModel as? ActivityCollateralModel,
			      let withdrawCollateralToken = findTokenInGlobalAssetsList(
			      	tokenId: withdrawCollateralActivityModel
			      		.detail.tokens[0].tokenID
			      ) else {
				return nil
			}
			resultActivity.withdrawCollateralDetailsVM = WithdrawCollateralActivityDetailsViewModel(
				activityModel: withdrawCollateralActivityModel,
				token: withdrawCollateralToken
			)
			return resultActivity
		case .enable_collateral, .disable_collateral:
			guard let enableCollateralActivityModel = activityDefaultModel as? ActivityCollateralModel,
			      let enableCollateralToken = findTokenInGlobalAssetsList(
			      	tokenId: enableCollateralActivityModel.detail
			      		.tokens[0].tokenID
			      ) else {
				return nil
			}
			resultActivity.collateralStatusDetailsVM = CollateralStatusActivityDetailsViewModel(
				activityModel: enableCollateralActivityModel,
				token: enableCollateralToken
			)
			return resultActivity
		case .approve:
			guard let approveActivityModel = activityDefaultModel as? ActivityApproveModel,
			      var approveToken = findTokenInGlobalAssetsList(tokenId: approveActivityModel.detail.tokenID) else {
				return nil
			}
			if approveToken.isEth {
				guard let wethToken = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }) else {
					return nil
				}
				approveToken = wethToken
			}
			resultActivity.approveDetailsVM = ApproveActivityDetailsViewModel(
				activityModel: approveActivityModel,
				token: approveToken
			)
			return resultActivity
		}
	}

	private func separateActivitiesByDay(activities: [ActivityCellViewModel]) -> SeparatedActivitiesWithDayType {
		let currentDate = Date()
		var activityDate: Date
		var daysBetweenNowAndActivityTime: Int
		var result: SeparatedActivitiesWithDayType = [:]

		for activity in activities {
			activityDate = getActivityDate(activityBlockTime: activity.blockTime)
			daysBetweenNowAndActivityTime = Calendar.current.dateComponents([.day], from: activityDate, to: currentDate)
				.day!
			if let resultActivity = getActivityDetails(activity: activity) {
				if result[daysBetweenNowAndActivityTime] != nil {
					result[daysBetweenNowAndActivityTime]?.append(resultActivity)
				} else {
					result[daysBetweenNowAndActivityTime] = [resultActivity]
				}
			}
		}

		return result
	}

	private func sortSeparatedActivities(separatedActivitiesWithDay: SeparatedActivitiesWithDayType)
		-> SeparatedActivitiesType {
		var result: SeparatedActivitiesType = []
		var activityGroupTitle: String

		let sortedSeparatedActivitiesKeys = separatedActivitiesWithDay.keys.sorted()

		for activityGroupKey in sortedSeparatedActivitiesKeys {
			guard let activityGroup = separatedActivitiesWithDay[activityGroupKey] else {
				fatalError("there is no activity in separated activities")
			}

			if activityGroupKey == 0 {
				activityGroupTitle = "Today"
			} else if activityGroupKey == 1 {
				activityGroupTitle = "Yesterday"
			} else {
				let firstactivityInGroupDate = getActivityDate(activityBlockTime: activityGroup[0].blockTime)
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "MMM d yyyy"
				activityGroupTitle = dateFormatter.string(from: firstactivityInGroupDate)
			}

			result.append((title: activityGroupTitle, activities: activityGroup))
		}
		return result
	}
}

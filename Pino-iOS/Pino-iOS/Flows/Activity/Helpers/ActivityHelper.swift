//
//  ActivitySeparatorWithTime.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/3/23.
//

import Combine
import Foundation

class ActivityHelper {
	// MARK: - TypeAliases

	public typealias SeparatedActivitiesType = [(title: String, activities: [ActivityCellViewModel])]
	public typealias SeparatedActivitiesWithDayType = [Int: [ActivityCellViewModel]]
	public typealias ActivitiesInfoType = (
		indexPaths: [IndexPath],
		sections: [IndexSet],
		finalSeparatedActivities: SeparatedActivitiesType
	)

	// MARK: - Private Properties

	private var globalAssetsList: [AssetViewModel]?
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init() {
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupBindings() {
		GlobalVariables.shared.$manageAssetsList.sink { globalTokens in
			self.globalAssetsList = globalTokens
			self.cancellables.removeAll()
		}.store(in: &cancellables)
	}

	// MARK: - Public Methods

	public func iterateActivityModel(activity: ResultActivityModel) -> ActivityModelProtocol {
		switch activity {
		case let .swap(swapActivity):
			return swapActivity
		case let .transfer(transferActivity):
			return transferActivity
		case let .transfer_from(transferActivity):
			return transferActivity
//		case let .borrow(borrowActivity):
//			return borrowActivity
//		case let .repay(repayActvity):
//			return repayActvity
		case let .withdraw(withdrawActivity):
			return withdrawActivity
		case let .invest(investActivity):
			return investActivity
		case let .collateral(collateralActivity):
			return collateralActivity
		case let .approve(approveActivity):
			return approveActivity
		case let .wrap(wrapActivity):
			return wrapActivity
		case let .unwrap(unwrapActivity):
			return unwrapActivity
		case let .unknown(baseActivity):
			return baseActivity
		}
	}

	public func iterateActivitiesFromResponse(activities: ActivitiesModel) -> [ActivityModelProtocol] {
		var iteratedActivities: [ActivityModelProtocol] = []
		for activity in activities {
			let iteratedActivity = iterateActivityModel(activity: activity)
			// prevent crash if activity have other type
			if ActivityType(rawValue: iteratedActivity.type) != nil {
				iteratedActivities.append(iteratedActivity)
			}
		}
		return iteratedActivities
	}

	public func iterateCoreDataActivity(coreDataActivity: CDActivityParent) -> ActivityModelProtocol {
		switch ActivityType(rawValue: coreDataActivity.type) {
		case .swap:
			let cdSwapActivity = coreDataActivity as! CDSwapActivity
			return ActivitySwapModel(cdSwapActivityModel: cdSwapActivity)
		case .transfer:
			let cdTransferActivity = coreDataActivity as! CDTransferActivity
			return ActivityTransferModel(cdTransferActivityModel: cdTransferActivity)
		case .transfer_from:
			let cdTransferActivity = coreDataActivity as! CDTransferActivity
			return ActivityTransferModel(cdTransferActivityModel: cdTransferActivity)
		case .approve:
			let cdApproveActivity = coreDataActivity as! CDApproveActivity
			return ActivityApproveModel(cdApproveActivityModel: cdApproveActivity)
		case .create_investment, .increase_investment:
			let cdInvestActivity = coreDataActivity as! CDInvestActivity
			return ActivityInvestModel(cdInvestActivityModel: cdInvestActivity)
		case .decrease_investment, .withdraw_investment:
			let cdWithdrawActivity = coreDataActivity as! CDWithdrawActivity
			return ActivityWithdrawModel(cdWithDrawActivityModel: cdWithdrawActivity)
//		case .borrow:
//			let cdBorrowActivity = coreDataActivity as! CDBorrowActivity
//			return ActivityBorrowModel(cdBorrowActivityModel: cdBorrowActivity)
//		case .repay:
//			let cdRepayActivity = coreDataActivity as! CDRepayActivity
//			return ActivityRepayModel(cdRepayActivityModel: cdRepayActivity)
//		case .increase_collateral, .decrease_collateral, .create_collateral, .remove_collateral,
//		     .enable_collateral,
//		     .disable_collateral:
//			let cdCollateralActivity = coreDataActivity as! CDCollateralActivity
//			return ActivityCollateralModel(cdCollateralActivityModel: cdCollateralActivity)
		case .create_collateral:
			let cdCollateralActivity = coreDataActivity as! CDCollateralActivity
			return ActivityCollateralModel(cdCollateralActivityModel: cdCollateralActivity)
		case .wrap_eth, .swap_wrap:
			let cdWrapETHActivity = coreDataActivity as! CDWrapETHActivity
			return ActivityWrapETHModel(cdWrapActivityModel: cdWrapETHActivity)
		case .unwrap_eth, .swap_unwrap:
			let cdUnwrapETHActivity = coreDataActivity as! CDUnwrapETHActivity
			return ActivityUnwrapETHModel(cdUnwrapActivityModel: cdUnwrapETHActivity)
		default:
			fatalError("Unknown activity type from coredata")
		}
	}

	public func getActivityDate(activityBlockTime: String) -> Date {
		activityBlockTime.serverFormattedDate
	}

	public func getServerFormattedStringDate(date: Date) -> String {
		date.serverFormattedDate
	}

	public func separateActivitiesByTime(activities: [ActivityCellViewModel]) -> SeparatedActivitiesType {
		var separatedActivitiesWithDay: SeparatedActivitiesWithDayType

		separatedActivitiesWithDay = separateActivitiesByDay(activities: activities)

		return sortSeparatedActivities(separatedActivitiesWithDay: separatedActivitiesWithDay)
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
//		case .borrow:
//			guard let borrowActivityModel = activityDefaultModel as? ActivityBorrowModel,
//			      let borrowToken = findTokenInGlobalAssetsList(tokenId: borrowActivityModel.detail.token.tokenID)
//			else {
//				return nil
//			}
//			resultActivity.borrowDetailsVM = BorrowActivityDetailsViewModel(
//				activityModel: borrowActivityModel,
//				token: borrowToken
//			)
//			return resultActivity
//		case .repay, .repay_behalf:
//			guard let repayActivityModel = activityDefaultModel as? ActivityRepayModel,
//			      let repayToken = findTokenInGlobalAssetsList(tokenId: repayActivityModel.detail.repaidToken.tokenID)
//			else {
//				return nil
//			}
//			resultActivity.repayDetailsVM = RepayActivityDetailsViewModel(
//				activityModel: repayActivityModel,
//				token: repayToken
//			)
//			return resultActivity
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
		case .create_collateral /* , .increase_collateral */:
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
//		case .remove_collateral, .decrease_collateral:
//			guard let withdrawCollateralActivityModel = activityDefaultModel as? ActivityCollateralModel,
//			      let withdrawCollateralToken = findTokenInGlobalAssetsList(
//			      	tokenId: withdrawCollateralActivityModel
//			      		.detail.tokens[0].tokenID
//			      ) else {
//				return nil
//			}
//			resultActivity.withdrawCollateralDetailsVM = WithdrawCollateralActivityDetailsViewModel(
//				activityModel: withdrawCollateralActivityModel,
//				token: withdrawCollateralToken
//			)
//			return resultActivity
//		case .enable_collateral, .disable_collateral:
//			guard let enableCollateralActivityModel = activityDefaultModel as? ActivityCollateralModel,
//			      let enableCollateralToken = findTokenInGlobalAssetsList(
//			      	tokenId: enableCollateralActivityModel.detail
//			      		.tokens[0].tokenID
//			      ) else {
//				return nil
//			}
//			resultActivity.collateralStatusDetailsVM = CollateralStatusActivityDetailsViewModel(
//				activityModel: enableCollateralActivityModel,
//				token: enableCollateralToken
//			)
//			return resultActivity
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
		case .wrap_eth, .swap_wrap:
			guard let wrapActivityModel = activityDefaultModel as? ActivityWrapETHModel,
			      let ethToken = globalAssetsList?.first(where: { $0.isEth }),
			      let wethToken = globalAssetsList?.first(where: { $0.isWEth }) else {
				return nil
			}
			resultActivity.wrapDetailsVM = WrapActivityDetailsViewModel(
				activityModel: wrapActivityModel,
				fromToken: ethToken,
				toToken: wethToken
			)
			return resultActivity
		case .unwrap_eth, .swap_unwrap:
			guard let unwrapActivityModel = activityDefaultModel as? ActivityUnwrapETHModel,
			      let ethToken = globalAssetsList?.first(where: { $0.isEth }),
			      let wethToken = globalAssetsList?.first(where: { $0.isWEth }) else {
				return nil
			}
			resultActivity.unwrapDetailsVM = UnwrapActivityDetailsViewModel(
				activityModel: unwrapActivityModel,
				fromToken: wethToken,
				toToken: ethToken
			)
			return resultActivity
		}
	}

	private func separateActivitiesByDay(activities: [ActivityCellViewModel]) -> SeparatedActivitiesWithDayType {
		let currentStringDate = getServerFormattedStringDate(date: Date())
		let currentDate = getActivityDate(activityBlockTime: currentStringDate)
		var activityDate: Date
		var daysBetweenNowAndActivityTime: Int
		var result: SeparatedActivitiesWithDayType = [:]

		for activity in activities {
			activityDate = getActivityDate(activityBlockTime: activity.blockTime)
			let calendar = Calendar.current
			let activityStartOfDayTime = calendar.startOfDay(for: activityDate)
			let currentStartOfDayTime = calendar.startOfDay(for: currentDate)
			daysBetweenNowAndActivityTime = calendar.dateComponents(
				[.day],
				from: activityStartOfDayTime,
				to: currentStartOfDayTime
			)
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
				dateFormatter.locale = Locale(identifier: Date().timeZoneIdentifier)
				dateFormatter.timeZone = TimeZone(secondsFromGMT: Date().timeZoneSecondsFromGMT)
				activityGroupTitle = dateFormatter.string(from: firstactivityInGroupDate)
			}

			if let foundIndex = result.firstIndex(where: { $0.title == activityGroupTitle }) {
				result[foundIndex].activities.append(contentsOf: activityGroup)
			} else {
				result.append((title: activityGroupTitle, activities: activityGroup))
			}
		}
		return result
	}
}

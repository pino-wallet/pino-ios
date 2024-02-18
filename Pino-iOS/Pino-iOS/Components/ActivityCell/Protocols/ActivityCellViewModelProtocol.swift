//
//  ActivityCellViewModelProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/1/23.
//

import Foundation

protocol ActivityCellViewModelProtocol {
	var icon: String! { get }
	var title: String! { get }
	var blockTime: String { get }
	var status: ActivityCellStatus { get }
	var uiType: ActivityUIType { get }
	var activityType: ActivityType { get }
	var defaultActivityModel: any ActivityModelProtocol { get }
	var activityMoreInfo: String! { get }
}

public enum ActivityCellStatus: String {
	case failed = "Failed"
	case success = "Success"
	case pending = "Pending..."
}

public enum ActivityUIType {
	case swap
	case borrow
	case send
	case receive
	case collateral
	case withdraw_collateral
	case invest
	case repay
	case withdraw_investment
	case enable_collateral
	case disable_collateral
	case approve
}

//
//  ActivityCellViewModelProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/1/23.
//

import Foundation

protocol ActivityCellViewModelProtocol {
	var globalAssetsList: [AssetViewModel] { get set }
	var icon: String { get }
	var title: String { get }
	var formattedTime: String { get }
	var blockTime: String { get }
	var status: ActivityCellStatus { get }
	var uiType: ActivityUIType { get }
	var activityType: ActivityType { get }
	var currentAddress: String { get }
	var defaultActivityModel: ActivityModel { get }
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
	case unknown
	case collateral
	case un_collateral
	case invest
	case repay
	case withdraw
}

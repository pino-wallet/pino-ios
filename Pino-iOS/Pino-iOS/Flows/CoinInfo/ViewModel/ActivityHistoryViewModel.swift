//
//  ActionHistoryViewModel.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/28/23.
//

import Foundation

struct ActivityHistoryViewModel {
	// MARK: - Public Properties

	public var activityHistoryModel: ActivityHistoryModel!

	public var activityIcon: String {
		activityHistoryModel.activityIcon
	}

	public var activityTitle: String {
		activityHistoryModel.activityTitle
	}

	public var time: String {
		activityHistoryModel.time
	}

	public var status: ActivityStatus {
		if let status = activityHistoryModel.status {
			return status
		} else {
			return .success
		}
	}
}

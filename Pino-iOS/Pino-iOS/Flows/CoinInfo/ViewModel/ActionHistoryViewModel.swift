//
//  ActionHistoryViewModel.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/28/23.
//

import Foundation

struct ActionHistoryViewModel {
	// MARK: - Public Properties

	public var actionHistoryModel: ActionHistoryModel!

	public var actionIcon: String {
		actionHistoryModel.actinIcon
	}

	public var actionTitle: String {
		actionHistoryModel.actionTitle
	}

	public var time: String {
		actionHistoryModel.time
	}

	public var status: ActionStatus {
		if let status = actionHistoryModel.status {
			return status
		} else {
			return .success
		}
	}
}

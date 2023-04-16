//
//  ChartDateFilter.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//

public enum ChartDateFilter: String {
	case hour = "1H"
	case day = "1D"
	case week = "1W"
	case month = "1M"
	case year = "1Y"
	case all = "All"

	public var timeFrame: String {
		switch self {
		case .hour:
			return "1h"
		case .day:
			return "1d"
		case .week:
			return "7d"
		case .month:
			return "1m"
		case .year:
			return "1y"
		case .all:
			return "all"
		}
	}
}

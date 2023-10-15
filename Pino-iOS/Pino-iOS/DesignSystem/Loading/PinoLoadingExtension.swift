//
//  PinoLoadingType.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/14/23.
//

import Foundation

extension PinoLoading {
	public enum ImageType: String {
		case primary = "loading"
		case rainbow = "rainbow_loading"
		case secondary = "secondary_loading"
	}

	public enum SpeedType: Double {
		case normal = 0.7
		case fast = 0.5
	}
}

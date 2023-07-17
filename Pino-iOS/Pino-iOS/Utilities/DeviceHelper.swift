//
//  DeviceSize.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/17/23.
//

import Foundation
import UIKit

class DeviceHelper {
	// MARK: - Public Properties

	public static let shared = DeviceHelper()
	public let size: Size

	// MARK: - Initializers

	init() {
		if UIScreen.main.bounds.height < 730 {
			self.size = .small
		} else {
			self.size = .normal
		}
	}
}

extension DeviceHelper {
	public enum Size {
		case small
		case normal
	}
}

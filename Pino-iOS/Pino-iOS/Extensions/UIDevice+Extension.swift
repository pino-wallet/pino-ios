//
//  UIDevice+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/24/23.
//

import Foundation
import UIKit

extension UIDevice {
	var isSimulator: Bool {
		#if targetEnvironment(simulator)
			return true
		#else
			return false
		#endif
	}
}

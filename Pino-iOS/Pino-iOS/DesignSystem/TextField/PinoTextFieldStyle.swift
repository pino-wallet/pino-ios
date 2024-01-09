//
//  PinoTextFieldStyle.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

extension PinoTextFieldView {
	public enum Style {
		case normal
		case error
		case success
		case customIcon(UIView)
		case pending
	}

	public enum Pattern {
		case number
		case alphaNumeric
	}
}

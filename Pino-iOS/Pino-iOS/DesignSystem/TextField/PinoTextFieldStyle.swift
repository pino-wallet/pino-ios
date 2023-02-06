//
//  PinoTextFieldStyle.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/1/23.
//

import UIKit

extension PinoTextFieldView {
	public struct Style: Equatable {
		public let placeholderColor: UIColor
		public let textColor: UIColor
		public let borderColor: UIColor
		public let editingBorderColor: UIColor
		public let type: String
	}
}

extension PinoTextFieldView.Style {
	public static let normal = PinoTextFieldView.Style(
		placeholderColor: .Pino.gray2,
		textColor: .Pino.label,
		borderColor: .Pino.gray5,
		editingBorderColor: .Pino.green3,
		type: "normal"
	)
	public static let error = PinoTextFieldView.Style(
		placeholderColor: .Pino.gray2,
		textColor: .Pino.label,
		borderColor: .Pino.gray5,
		editingBorderColor: .Pino.green3,
		type: "error"
	)
	public static let customRightView = PinoTextFieldView.Style(
		placeholderColor: .Pino.gray2,
		textColor: .Pino.label,
		borderColor: .Pino.gray5,
		editingBorderColor: .Pino.green3,
		type: "customRightView"
	)
}

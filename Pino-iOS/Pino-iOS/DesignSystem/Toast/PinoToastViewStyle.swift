//
//  PinoToastViewStyle.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/25/22.
//

import UIKit

// MARK: - PinoButton Style

extension PinoToastView {
	// Specifies a visual theme of the button
	public struct Style: Equatable {
		public let tintColor: UIColor
		public let backgroundColor: UIColor
		public let hasShadow: Bool
	}
}

// MARK: - Custom Button Styles

extension PinoToastView.Style {
	public static let primary = PinoToastView.Style(
		tintColor: .Pino.white,
		backgroundColor: .Pino.primary,
		hasShadow: false
	)
	public static let secondary = PinoToastView.Style(
		tintColor: .Pino.label,
		backgroundColor: .Pino.secondaryBackground,
		hasShadow: true
	)
	public static let error = PinoToastView.Style(
		tintColor: .Pino.errorRed,
		backgroundColor: .Pino.secondaryBackground,
		hasShadow: true
	)
}

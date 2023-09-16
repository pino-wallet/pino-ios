//
//  PinoColor.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

extension UIColor {
	// MARK: Custom Font

	public enum Pino {
		// MARK: - Primary

		public static let primary = UIColor(named: "Primary Color") ?? UIColor.systemGreen

		// MARK: - Background

		static let background = UIColor(named: "Background Color") ?? UIColor.systemBackground
		static let secondaryBackground = UIColor(named: "Secondary Background Color") ?? UIColor
			.secondarySystemBackground

		// MARK: - Label

		static let label = UIColor(named: "Label Color") ?? UIColor.label
		static let secondaryLabel = UIColor(named: "Secondary Label Color") ?? UIColor.secondaryLabel

		// MARK: - States

		static let pendingOrange = UIColor(named: "Pending Orange Color") ?? UIColor.orange
		static let successGreen = UIColor(named: "Success Green Color") ?? UIColor.green
		static let succesGreen2 = UIColor(named: "Success Green 2 Color") ?? UIColor.green
		static let errorRed = UIColor(named: "Error Red Color") ?? UIColor.red

		// MARK: - Gray

		static let gray1 = UIColor(named: "Gray 1 Color") ?? UIColor.systemGray
		static let gray2 = UIColor(named: "Gray 2 Color") ?? UIColor.systemGray2
		static let gray3 = UIColor(named: "Gray 3 Color") ?? UIColor.systemGray3
		static let gray4 = UIColor(named: "Gray 4 Color") ?? UIColor.systemGray4
		static let gray5 = UIColor(named: "Gray 5 Color") ?? UIColor.systemGray5
		static let gray6 = UIColor(named: "Gray 6 Color") ?? UIColor.systemGray6

		// MARK: - Green

		static let green1 = UIColor(named: "Green 1 Color") ?? UIColor.systemGreen
		static let green2 = UIColor(named: "Green 2 Color") ?? UIColor.systemGreen
		static let green3 = UIColor(named: "Green 3 Color") ?? UIColor.systemGreen
		static let green4 = UIColor(named: "Green 4 Color") ?? UIColor.systemGreen
		static let green5 = UIColor(named: "Green 5 Color") ?? UIColor.systemGreen
		static let green6 = UIColor(named: "Green 6 Color") ?? UIColor.systemGreen

		// MARK: - Other

		static let white = UIColor(named: "White Color") ?? UIColor.white
		static let black = UIColor(named: "Black Color") ?? UIColor.black
		static let red = UIColor(named: "Red Color") ?? UIColor.red
		static let blue = UIColor(named: "Blue Color") ?? UIColor.blue
		static let green = UIColor(named: "Green Color") ?? UIColor.green
		static let orange = UIColor(named: "Orange Color") ?? UIColor.orange
		static let cream = UIColor(named: "Cream Color") ?? UIColor.yellow
		static let lightRed = UIColor(named: "Light Red Color") ?? UIColor.red
		static let lightOrange = UIColor(named: "Light Orange Color") ?? UIColor.orange
		static let lightBlue = UIColor(named: "Light Blue Color") ?? UIColor.blue
		static let lightGreen = UIColor(named: "Light Green Color") ?? UIColor.green
		static let clear = UIColor(named: "Clear Color") ?? UIColor.clear
	}
}

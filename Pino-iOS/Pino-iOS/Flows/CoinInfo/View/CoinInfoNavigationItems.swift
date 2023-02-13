//
//  CoinInfoNavigationItems.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/12/23.
//

import UIKit

class CoinInfoNavigationItems {
	// MARK: - Public properties

	public static var coinTitle: UILabel {
		let coinTitle = PinoLabel(style: .title, text: nil)
		coinTitle.font = .PinoStyle.semiboldBody
		coinTitle.text = "BTC"
		coinTitle.textColor = UIColor.Pino.white
		return coinTitle
	}

	public static var chartButton: UIBarButtonItem {
		let chartButton = UIBarButtonItem(
			image: UIImage(named: "chart"),
			style: .plain,
			target: self,
			action: nil
		)
		chartButton.tintColor = .Pino.white
		return chartButton
	}
}

//
//  CoinInfoNavigationItems.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/12/23.
//

import UIKit

class CoinInfoNavigationItems {
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
		chartButton.tintColor = .white
		return chartButton
	}

	public static var closeButton: UIBarButtonItem {
		let closeButton = UIBarButtonItem(
			image: UIImage(named: "close"),
			style: .plain,
			target: self,
			action: nil
		)
		closeButton.tintColor = .white
		return closeButton
	}
}

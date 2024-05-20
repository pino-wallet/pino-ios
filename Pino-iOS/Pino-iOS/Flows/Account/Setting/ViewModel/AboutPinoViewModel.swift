//
//  AboutPinoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

import Foundation

struct AboutPinoViewModel {
	// MARK: Public Properties

	public let logo = "appAboutIcon"
	public let name = "Pino"
	public let version = "Version 1.0.0"
	public let termsOfServiceURL = "https://pino.xyz/terms-of-use"
	public let privacyPolicyURL = "https://pino.xyz/privacy-policy"
	public let websiteURL = "https://pino.xyz"
	public var builtByNitoText: NSMutableAttributedString {
		let nitoLabsURL = URL(string: "http://nitolabs.com")!
		let attributedText = NSMutableAttributedString(string: "Built by Nito Labs Ltd ©")
		let nitoLabsURLRange = (attributedText.string as NSString).range(of: "Nito Labs Ltd")
		attributedText.setAttributes([.link: nitoLabsURL], range: nitoLabsURLRange)
		return attributedText
	}
}

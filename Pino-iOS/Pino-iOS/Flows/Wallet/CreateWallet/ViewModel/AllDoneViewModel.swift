//
//  AllDoneViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//

import UIKit

struct AllDoneViewModel {
	// MARK: Public Properties

	public let image = UIImage(named: "pino_logo")
	public let title = "You’re all done!"
	public let description = "A one line description should be here"
	public let continueButtonTitle = "Get started"

	public var agreementAttributedTest: NSMutableAttributedString {
		#warning("This must be replaced with pino urls")
		let temporaryTermOfServiceURL = URL(string: "http://google.com/")!
		let temporaryPrivacyPolicyURL = URL(string: "http://google.com/")!
		let attributedText = NSMutableAttributedString(string: "I agree to the Term of use and Privacy policy")
		let termOfUseRange = (attributedText.string as NSString).range(of: "Term of use")
		let privacyPolicyRange = (attributedText.string as NSString).range(of: "Privacy policy")
		attributedText.setAttributes([.link: temporaryTermOfServiceURL], range: termOfUseRange)
		attributedText.setAttributes([.link: temporaryPrivacyPolicyURL], range: privacyPolicyRange)
		return attributedText
	}
}

//
//  ImportAccountTextViewProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/20/23.
//

import UIKit

protocol ImportTextViewType: UITextView {
	var errorStackView: UIStackView { get set }
	var enteredWordsCount: UILabel { get set }
	var importKeyCountVerified: ((Bool) -> Void)? { get set }
	func pasteText()
}

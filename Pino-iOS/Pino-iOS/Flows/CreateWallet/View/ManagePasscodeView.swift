//
//  CreatePassView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/16/22.
//

import Foundation
import UIKit

class ManagePasscodeView: UIView {
	// MARK: Private Properties

	private let managePassTitle = UILabel()
	private let managePassDescription = UILabel()
	private let topInfoContainerView = UIStackView()
	private let errorLabel = UILabel()
	private let managePassVM: PasscodeManagerPages!
	private var keyboardSize = CGSize(
		width: .zero,
		height: 320
	) // Minimum height in rare case keyboard of height was not calculated

	// MARK: Public Properties

	public let passDotsView: PassDotsView!

	// MARK: Initializers

	init(managePassVM: PasscodeManagerPages) {
		self.managePassVM = managePassVM
		self.passDotsView = PassDotsView(passcodeManagerVM: managePassVM)
		super.init(frame: .zero)

		setupNotifications()
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension ManagePasscodeView {
	// MARK: UI Methods

	private func setupNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
	}

	private func setupView() {
		topInfoContainerView.addArrangedSubview(managePassTitle)
		topInfoContainerView.addArrangedSubview(managePassDescription)

		addSubview(topInfoContainerView)
		addSubview(passDotsView)
		addSubview(errorLabel)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		topInfoContainerView.axis = .vertical
		topInfoContainerView.spacing = 18

		managePassTitle.text = managePassVM.title
		managePassTitle.textColor = .Pino.label
		managePassTitle.font = .PinoStyle.semiboldTitle3

		errorLabel.isHidden = true
		errorLabel.textColor = .Pino.errorRed
		errorLabel.font = UIFont.PinoStyle.mediumTitle3

		managePassDescription.text = managePassVM.description
		managePassDescription.textColor = .Pino.secondaryLabel
		managePassDescription.font = .PinoStyle.mediumCallout
		managePassDescription.numberOfLines = 0
	}

	public func showErrorWith(text: String) {
		errorLabel.text = text
		errorLabel.isHidden = false
	}

	private func setupContstraint() {
		topInfoContainerView.pin(
			.top(padding: 115),
			.horizontalEdges(padding: 16)
		)

		passDotsView.pin(
			.top(to: topInfoContainerView, padding: 89),
			.centerX(),
			.centerY(padding: -50),
			.fixedHeight(20)
		)

		errorLabel.pin(
			.centerX,
			.bottom(padding: keyboardSize.height + 20)
		)
	}
}

extension ManagePasscodeView {
	// swiftlint: redundant_void_return
	@objc
	internal func keyboardWillShow(_ notification: Notification?) {
		var kbSize: CGSize!
		if let info = notification?.userInfo {
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			//  Getting UIKeyboardSize.
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				let screenSize = UIScreen.main.bounds
				let intersectRect = kbFrame.intersection(screenSize)
				if intersectRect.isNull {
					kbSize = CGSize(width: screenSize.size.width, height: 0)
				} else {
					kbSize = intersectRect.size
				}
				keyboardSize = kbSize
			}
		}
	}
}

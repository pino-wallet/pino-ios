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

	private let managePassTitle = PinoLabel(style: .title, text: nil)
	private let managePassDescription = PinoLabel(style: .description, text: nil)
	private let topInfoContainerView = UIStackView()
	private let errorLabel = UILabel()
	private let managePassVM: PasscodeManagerPages
	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated

	// MARK: Public Properties

	public let passDotsView: PassDotsView

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
		managePassDescription.text = managePassVM.description

		errorLabel.isHidden = true
		errorLabel.textColor = .Pino.errorRed
		errorLabel.font = UIFont.PinoStyle.mediumTitle3
	}

	public func showErrorWith(text: String) {
		errorLabel.text = text
		errorLabel.isHidden = false
	}

	public func hideError() {
		errorLabel.isHidden = true
	}

	private func setupContstraint() {
		topInfoContainerView.pin(
			.top(to: layoutMarginsGuide, padding: 25),
			.horizontalEdges(padding: 16)
		)

		passDotsView.pin(
			.relative(.top, 90, to: topInfoContainerView, .bottom),
			.centerX(),
			.fixedHeight(20)
		)

		errorLabel.pin(
			.centerX,
			.bottom(to: layoutMarginsGuide, padding: keyboardHeight - 16)
		)
	}
}

extension ManagePasscodeView {
	// swiftlint: redundant_void_return
	@objc
	internal func keyboardWillShow(_ notification: Notification?) {
		if let info = notification?.userInfo {
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			//  Getting UIKeyboardSize.
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				let screenSize = UIScreen.main.bounds
				let intersectRect = kbFrame.intersection(screenSize)
				if intersectRect.isNull {
					keyboardHeight = 0
				} else {
					keyboardHeight = intersectRect.size.height
				}
			}
		}
	}
}

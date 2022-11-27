//
//  PassDotsView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/16/22.
//

import Combine
import Foundation
import UIKit

class PassDotsView: UIView {
	// MARK: Private Properties

	private let passDotsContainerView = UIStackView()
	private var passcodeManagerVM: PasscodeManagerPages

	// MARK: Initializers

	init(passcodeManagerVM: PasscodeManagerPages) {
		self.passcodeManagerVM = passcodeManagerVM
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension PassDotsView {
	// MARK: UI Methods

	private func setupView() {
		addSubview(passDotsContainerView)
		createDotsView()
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		passDotsContainerView.axis = .horizontal
		passDotsContainerView.distribution = .equalCentering
		passDotsContainerView.spacing = 14
		passDotsContainerView.alignment = .center
	}

	private func setupContstraint() {
		passDotsContainerView.pin(
			.allEdges
		)
		passDotsContainerView.widthAnchor
			.constraint(lessThanOrEqualToConstant: CGFloat(passcodeManagerVM.passDigitsCount * 34)).isActive = true
	}

	private func createDotsView() {
		for _ in 0 ..< passcodeManagerVM.passDigitsCount {
			let dotView = UIView()
			dotView.pin(
				.fixedHeight(20),
				.fixedWidth(20)
			)
			dotView.layer.cornerRadius = 10
			dotView.layer.borderWidth = 1.2
			setStyle(of: dotView, withState: .empty)
			passDotsContainerView.addArrangedSubview(dotView)
		}
	}

	func setStyle(of dotView: UIView, withState state: PassdotState) {
		switch state {
		case .fill:
			dotView.backgroundColor = .Pino.green3
			dotView.layer.borderColor = UIColor.Pino.clear.cgColor
		case .empty:
			dotView.backgroundColor = .Pino.white
			dotView.layer.borderColor = UIColor.Pino.gray4.cgColor
		case .error:
			dotView.backgroundColor = .Pino.white
			dotView.layer.borderColor = UIColor.Pino.errorRed.cgColor
		}
	}

	func showErrorState() {
		passDotsContainerView.subviews.forEach { dotView in
			setStyle(of: dotView, withState: .error)
		}
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.resetDotsView()
		}
	}

	func resetDotsView() {
		passcodeManagerVM.passcode = ""
		passDotsContainerView.subviews.forEach { dotView in
			self.setStyle(of: dotView, withState: .empty)
		}
	}

	enum PassdotState {
		case fill
		case empty
		case error
	}
}

// Confirming to UIKeyInput In order to show keyboard
// swiftlint: disable unused_setter_value
extension PassDotsView: UIKeyInput, UITextInputTraits {
	// MARK: Overrides

	override var canBecomeFirstResponder: Bool { true }
	override var canResignFirstResponder: Bool { true }

	var hasText: Bool { passcodeManagerVM.passcode?.isEmpty == false }

	var keyboardType: UIKeyboardType { get { UIKeyboardType.numberPad } set {} }

	func insertText(_ text: String) {
		setDotviewStyleAt(index: passcodeManagerVM.passcode?.count ?? 0, withState: .fill)
		passcodeManagerVM.passInserted(passChar: text)
	}

	func deleteBackward() {
		guard let passCode = passcodeManagerVM.passcode else { return }
		passcodeManagerVM.passRemoved()
		setDotviewStyleAt(index: passCode.count, withState: .empty)
	}

	func setDotviewStyleAt(index: Int, withState state: PassdotState) {
		guard passDotsContainerView.subviews.isIndexValid(index: index) else { return }
		let fillingDotView = passDotsContainerView.subviews[index]
		setStyle(of: fillingDotView, withState: state)
	}
}

//
//  PassDotsView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/16/22.
//

import Foundation
import UIKit

struct CreatePassVM {
	public var passDigitsCount = 6
	public var passwordText = ""

	private func createPassword() {}

	private func verifyPassword() {}
}

class PassDotsView: UIView {
	// MARK: Private Properties

	private let passDotsContainerView = UIStackView()
	private var createPassVM: CreatePassVM!

	// MARK: Public Properties

	// MARK: Overrides

	var passDotInputView: UIView?

	override var canBecomeFirstResponder: Bool { true }
	override var canResignFirstResponder: Bool { true }

	override var inputView: UIView? {
		get { passDotInputView }
		set { passDotInputView = newValue }
	}

	// MARK: Initializers

	init(createPassVM: CreatePassVM) {
		self.createPassVM = createPassVM
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.becomeFirstResponder()
		}
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Public Methods

	// MARK: Private Methods
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
			.constraint(lessThanOrEqualToConstant: CGFloat(createPassVM.passDigitsCount * 34)).isActive = true
	}

	private func createDotsView() {
		for _ in 0 ..< createPassVM.passDigitsCount {
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
			dotView.layer.borderColor = UIColor.clear.cgColor
		case .empty:
			dotView.backgroundColor = .Pino.white
			dotView.layer.borderColor = UIColor.Pino.gray4.cgColor
		case .error:
			dotView.backgroundColor = .Pino.white
			dotView.layer.borderColor = UIColor.Pino.errorRed.cgColor
		}
	}

	enum PassdotState {
		case fill
		case empty
		case error
	}
}

// Confirming to UIKeyInput In order to show keyboard
extension PassDotsView: UIKeyInput, UITextInputTraits {
	var hasText: Bool { createPassVM.passwordText.isEmpty == false }

	var keyboardType: UIKeyboardType { get { UIKeyboardType.numberPad } set {} }

	func insertText(_ text: String) {
		guard createPassVM.passwordText.count < createPassVM.passDigitsCount else { return }
		createPassVM.passwordText.append(text)
		setDotviewStyleAt(index: createPassVM.passwordText.count - 1, withState: .fill)
	}

	func deleteBackward() {
		guard !createPassVM.passwordText.isEmpty else { return }
		_ = createPassVM.passwordText.popLast()
		setDotviewStyleAt(index: createPassVM.passwordText.count, withState: .empty)
	}

	func setDotviewStyleAt(index: Int, withState state: PassdotState) {
		guard passDotsContainerView.subviews.isIndexValid(index: index) else { return }
		let fillingDotView = passDotsContainerView.subviews[index]
		setStyle(of: fillingDotView, withState: state)
	}
}

extension Array {
	func isIndexValid(index: Int) -> Bool {
		indices.contains(index)
	}
}

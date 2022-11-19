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
	public var passwordText: String?

	private func createPassword() {

	}

	private func verifyPassword() {

	}
}

class PassDotsView: UIView {
	// MARK: Private Properties

	private let passDotsContainerView = UIStackView()
	private let createPassVM: CreatePassVM!

	// MARK: Public Properties

	// MARK: Overrides

	var _inputView: UIView?

   override var canBecomeFirstResponder: Bool { return true }
   override var canResignFirstResponder: Bool { return true }

   override var inputView: UIView? {
       set { _inputView = newValue }
       get { return _inputView }
   }

	// MARK: Initializers

	init(createPassVM: CreatePassVM) {
		self.createPassVM = passCreationVM
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
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
		createDotsView()
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		passDotsContainerView.axis = .horizontal
		passDotsContainerView.spacing = 14
	}

	private func setupContstraint() {}

	private func createDotsView() {
		for _ in 0 ..< passCreationVM.passDigitsCount {
			let dotView = UIView()
			dotView.pin(
				.fixedHeight(20),
				.fixedWidth(20)
			)
			setStyle(of: dotView, withState: .empty)
			passDotsContainerView.addArrangedSubview(dotView)
		}
	}

	func setStyle(of dotView: UIView, withState: PassdotState) {
		dotView.layer.cornerRadius = dotView.frame.width / 2
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
extension PassDotsView: UIKeyInput {
	
	typeAlias passwordText = createPassVM.passwordText
    
	var hasText: Bool { createPassVM.passwordText.isEmpty == false }
    
	func insertText(_ text: String) {
		guard passwordText.length <= createPassVM.passDigitsCount else { return }
		passwordText.append(text)
		setDotviewStyleAt(index: passwordText.length-1, withState: .fill)
	}

    func deleteBackward() {
		guard passwordText.lenght > 0 else {return}
        passwordText = passwordText.popLast()
		setDotviewStyleAt(index: passwordText.length, withState: .empty)
	}

	func setDotviewStyleAt(index: Int, withState state: PassdotState) {
		guard passDotsContainerView.subViews.isIndexValid else { return }
		let fillingDotView = passDotsContainerView.subViews[index]
		setStyle(of: fillingDotView, withState: state)
	}
}

extension Array {

	let isIndexValid = self.indices.contains(index)

}
//
//  PassDotsView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/16/22.
//

import Foundation
import UIKit

protocol PasscodeManagerPages {
	var title: String { get set }
	var description: String { get set }
	var passcode: String { get set }
	var passDigitsCount: Int { get }
	mutating func passInserted(passChar: String) // Added new pass number
	mutating func passRemoved() // Cleared last pass number
	var finishPassCreation: () -> Void { get set }
}

extension PasscodeManagerPages {
	var passDigitsCount: Int { 6 } // Default number of Password digits count

	mutating func passRemoved() {
		guard !passcode.isEmpty else { return }
		_ = passcode.popLast()
	}
}

class PassDotsView: UIView {
	// MARK: Private Properties

	private let passDotsContainerView = UIStackView()
	private var passcodeManagerVM: PasscodeManagerPages!

	// MARK: Public Properties

	// MARK: Initializers

	init(passcodeManagerVM: PasscodeManagerPages) {
		self.passcodeManagerVM = passcodeManagerVM
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
			dotView.layer.borderColor = UIColor.clear.cgColor
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.passDotsContainerView.subviews.forEach { dotView in
                self.setStyle(of: dotView, withState: .empty)
            }
        })
    }

	enum PassdotState {
		case fill
		case empty
		case error
	}
}

// Confirming to UIKeyInput In order to show keyboard
extension PassDotsView: UIKeyInput, UITextInputTraits {
	// MARK: Overrides

	override var canBecomeFirstResponder: Bool { true }
	override var canResignFirstResponder: Bool { true }

	var hasText: Bool { passcodeManagerVM.passcode.isEmpty == false }

	var keyboardType: UIKeyboardType { get { UIKeyboardType.numberPad } set {} }

	func insertText(_ text: String) {
		passcodeManagerVM.passInserted(passChar: text)
		setDotviewStyleAt(index: passcodeManagerVM.passcode.count - 1, withState: .fill)
	}

	func deleteBackward() {
		passcodeManagerVM.passRemoved()
		setDotviewStyleAt(index: passcodeManagerVM.passcode.count, withState: .empty)
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

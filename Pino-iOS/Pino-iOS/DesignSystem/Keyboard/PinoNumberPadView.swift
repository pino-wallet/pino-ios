//
//  PinoNumberPadView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/6/23.
//

import Combine
import Foundation
import UIKit

protocol PinoNumberPadDelegate {
	func insertText(_ text: String)
	func deleteBackward()
}

class PinoNumberPadView: UIView {
	// MARK: - Public Properties

	@Published
	public var inputs: [String] = []
	public var delegate: PinoNumberPadDelegate?

	// MARK: - Private Properties

	private let row1StackView = UIStackView()
	private let row2StackView = UIStackView()
	private let row3StackView = UIStackView()
	private let row4StackView = UIStackView()
	private let keysStackView = UIStackView()

	private let num0 = PinoButton(style: .numpad)
	private let num1 = PinoButton(style: .numpad)
	private let num2 = PinoButton(style: .numpad)
	private let num3 = PinoButton(style: .numpad)
	private let num4 = PinoButton(style: .numpad)
	private let num5 = PinoButton(style: .numpad)
	private let num6 = PinoButton(style: .numpad)
	private let num7 = PinoButton(style: .numpad)
	private let num8 = PinoButton(style: .numpad)
	private let num9 = PinoButton(style: .numpad)
	private let clearBtn = PinoButton(style: .numpad)
	private let emptyBtn = PinoButton(style: .numpad)
	private let hapticManager = HapticManager()

	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		row1StackView.addArrangedSubview(num1)
		row1StackView.addArrangedSubview(num2)
		row1StackView.addArrangedSubview(num3)

		row2StackView.addArrangedSubview(num4)
		row2StackView.addArrangedSubview(num5)
		row2StackView.addArrangedSubview(num6)

		row3StackView.addArrangedSubview(num7)
		row3StackView.addArrangedSubview(num8)
		row3StackView.addArrangedSubview(num9)

		row4StackView.addArrangedSubview(emptyBtn)
		row4StackView.addArrangedSubview(num0)
		row4StackView.addArrangedSubview(clearBtn)

		keysStackView.addArrangedSubview(row1StackView)
		keysStackView.addArrangedSubview(row2StackView)
		keysStackView.addArrangedSubview(row3StackView)
		keysStackView.addArrangedSubview(row4StackView)
		addSubview(keysStackView)
	}

	private func setupStyle() {
		emptyBtn.title = " "
		num0.title = "0"
		num1.title = "1"
		num2.title = "2"
		num3.title = "3"
		num4.title = "4"
		num5.title = "5"
		num6.title = "6"
		num7.title = "7"
		num8.title = "8"
		num9.title = "9"
		clearBtn.setImage(.init(named: "arrow_left_primary"), for: .normal)

		row1StackView.axis = .horizontal
		row1StackView.distribution = .fillEqually
		row1StackView.spacing = 2

		row2StackView.axis = .horizontal
		row2StackView.distribution = .fillEqually
		row2StackView.spacing = 2

		row3StackView.axis = .horizontal
		row3StackView.distribution = .fillEqually
		row3StackView.spacing = 2

		row4StackView.axis = .horizontal
		row4StackView.distribution = .fillEqually
		row4StackView.spacing = 2

		keysStackView.axis = .vertical
		keysStackView.spacing = 2

		num0.addTarget(self, action: #selector(num0Tapped), for: .touchUpInside)
		num1.addTarget(self, action: #selector(num1Tapped), for: .touchUpInside)
		num2.addTarget(self, action: #selector(num2Tapped), for: .touchUpInside)
		num3.addTarget(self, action: #selector(num3Tapped), for: .touchUpInside)
		num4.addTarget(self, action: #selector(num4Tapped), for: .touchUpInside)
		num5.addTarget(self, action: #selector(num5Tapped), for: .touchUpInside)
		num6.addTarget(self, action: #selector(num6Tapped), for: .touchUpInside)
		num7.addTarget(self, action: #selector(num7Tapped), for: .touchUpInside)
		num8.addTarget(self, action: #selector(num8Tapped), for: .touchUpInside)
		num9.addTarget(self, action: #selector(num9Tapped), for: .touchUpInside)
		clearBtn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
	}

	private func setupContstraint() {
		row1StackView.pin(.fixedHeight(70))
		row2StackView.pin(.fixedHeight(70))
		row3StackView.pin(.fixedHeight(70))
		row4StackView.pin(.fixedHeight(70))
		keysStackView.pin(
			.allEdges
		)
	}

	@objc
	private func num0Tapped() {
		tapped(number: "0")
	}

	@objc
	private func num1Tapped() {
		tapped(number: "1")
	}

	@objc
	private func num2Tapped() {
		tapped(number: "2")
	}

	@objc
	private func num3Tapped() {
		tapped(number: "3")
	}

	@objc
	private func num4Tapped() {
		tapped(number: "4")
	}

	@objc
	private func num5Tapped() {
		tapped(number: "5")
	}

	@objc
	private func num6Tapped() {
		tapped(number: "6")
	}

	@objc
	private func num7Tapped() {
		tapped(number: "7")
	}

	@objc
	private func num8Tapped() {
		tapped(number: "8")
	}

	@objc
	private func num9Tapped() {
		tapped(number: "9")
	}

	@objc
	private func clearTapped() {
		deleteBackward()
		let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
		hapticFeedback.impactOccurred()
	}

	private func tapped(number: String) {
		hapticManager.run(type: .lightImpact)
		insertText(number)
	}
}

extension PinoNumberPadView: UIKeyInput, UITextInputTraits {
	// MARK: Overrides

	override var canBecomeFirstResponder: Bool { true }
	override var canResignFirstResponder: Bool { true }

	var hasText: Bool {
		inputs.isEmpty ? false : true
	}

	func insertText(_ text: String) {
		inputs.append(text)
		delegate?.insertText(text)
	}

	func deleteBackward() {
		delegate?.deleteBackward()
		if !inputs.isEmpty {
			inputs.removeLast()
		}
	}
}

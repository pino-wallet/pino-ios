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
}

class PassDotsView: UIView {
	// MARK: Private Properties

	private let passDotsContainerView = UIStackView()
	private let passCreationVM: CreatePassVM!

	// MARK: Public Properties

	// MARK: Initializers

	init(passCreationVM: CreatePassVM) {
		self.passCreationVM = passCreationVM
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

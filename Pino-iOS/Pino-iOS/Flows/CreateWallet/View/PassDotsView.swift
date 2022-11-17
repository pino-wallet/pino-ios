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
	private var arrayOfDotsView: [UIView] = []
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
			dotView.layer.cornerRadius = dotView.frame.width / 2
			dotviewStyleBasedOnState(dotView, state: .empty)
			arrayOfDotsView.append(dotView)
			passDotsContainerView.addSubview(dotView)
		}
	}

	func dotviewStyleBasedOnState(_ view: UIView, state: PassdotState) {
		switch state {
		case .empty:
			view.backgroundColor = .Pino.green3
			view.layer.borderColor = UIColor.clear.cgColor
		case .fill:
			view.backgroundColor = .Pino.white
			view.layer.borderColor = UIColor.Pino.gray4.cgColor
		}
	}

	enum PassdotState {
		case fill
		case empty
	}
}

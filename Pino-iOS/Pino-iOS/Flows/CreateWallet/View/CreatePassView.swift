//
//  CreatePassView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/16/22.
//

import Foundation
import UIKit

class CreatePassView: UIView {
	// MARK: Private Properties

	private let createPassTitle = UILabel()
	private let createPassDesc = UILabel()
	private let topInfoContainerView = UIStackView()
	private let passDotsView: PassDotsView!

	// MARK: Public Properties

	private let createPassVM: CreatePassVM!

	// MARK: Initializers

	init(createPassVM: CreatePassVM) {
		self.createPassVM = createPassVM
		self.passDotsView = PassDotsView(createPassVM: createPassVM)
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

extension CreatePassView {
	// MARK: UI Methods

	private func setupView() {
		topInfoContainerView.addArrangedSubview(createPassTitle)
		topInfoContainerView.addArrangedSubview(createPassDesc)

		addSubview(topInfoContainerView)
		addSubview(passDotsView)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		topInfoContainerView.axis = .vertical
		topInfoContainerView.spacing = 18

		createPassTitle.text = "Create passcode"
		createPassTitle.textColor = .Pino.label
		createPassTitle.font = .PinoStyle.semiboldTitle3

		createPassDesc.text = "This passcode is for maximizing wallet security. It cannot be used to recover it."
		createPassDesc.textColor = .Pino.secondaryLabel
		createPassDesc.font = .PinoStyle.mediumCallout
		createPassDesc.numberOfLines = 0
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
	}
}

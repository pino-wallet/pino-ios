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
	public let passDotsView: PassDotsView!

	// MARK: Public Properties

	private let managePassVM: PasscodeManagerPages!

	// MARK: Initializers

	init(managePassVM: PasscodeManagerPages) {
		self.managePassVM = managePassVM
		self.passDotsView = PassDotsView(passcodeManagerVM: managePassVM)
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

extension ManagePasscodeView {
	// MARK: UI Methods

	private func setupView() {
		topInfoContainerView.addArrangedSubview(managePassTitle)
		topInfoContainerView.addArrangedSubview(managePassDescription)

		addSubview(topInfoContainerView)
		addSubview(passDotsView)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		topInfoContainerView.axis = .vertical
		topInfoContainerView.spacing = 18

		managePassTitle.text = managePassVM.title
		managePassTitle.textColor = .Pino.label
		managePassTitle.font = .PinoStyle.semiboldTitle3

		managePassDescription.text = managePassVM.description
		managePassDescription.textColor = .Pino.secondaryLabel
		managePassDescription.font = .PinoStyle.mediumCallout
		managePassDescription.numberOfLines = 0
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

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
	private let errorInfoStackView = UIStackView()
	private let errorInfoStackViewBottomConstant = CGFloat(40)
	private let keyboardview = PinoNumberPadView()

	// MARK: Public Properties

	public let passDotsView: PassDotsView

	// MARK: Initializers

	init(managePassVM: PasscodeManagerPages) {
		self.managePassVM = managePassVM
		self.passDotsView = PassDotsView(passcodeManagerVM: managePassVM)
		keyboardview.delegate = passDotsView
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension ManagePasscodeView {
	// MARK: Private Methods

	private func setupView() {
		topInfoContainerView.addArrangedSubview(managePassTitle)
		topInfoContainerView.addArrangedSubview(managePassDescription)

		errorInfoStackView.addArrangedSubview(errorLabel)

		addSubview(topInfoContainerView)
		addSubview(passDotsView)
		addSubview(errorInfoStackView)
		addSubview(keyboardview)
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

		errorInfoStackView.axis = .vertical
	}

	// MARK: - Public Methods

	public func showErrorWith(text: String) {
		errorLabel.text = text
		errorLabel.textAlignment = .center
		errorLabel.isHidden = false
	}

	public func hideError() {
		errorLabel.isHidden = true
	}

	private func setupContstraint() {
		errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true

		topInfoContainerView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(padding: 16)
		)

		passDotsView.pin(
			.relative(.top, 85, to: topInfoContainerView, .bottom),
			.centerX(),
			.fixedHeight(20)
		)

		errorInfoStackView.pin(
			.horizontalEdges(padding: 16)
		)

		keyboardview.pin(
			.horizontalEdges(padding: 27),
			.bottom(to: layoutMarginsGuide, padding: 32)
		)
	}
}

//
//  UnlockPasscodeView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/8/23.
//

import Foundation
import UIKit

class UnlockPasscodeView: UIView {
	// MARK: Private Properties

	private let unlockPageTitle = PinoLabel(style: .title, text: nil)
	private let topInfoContainerView = UIStackView()
	private let errorLabel = UILabel()
	private let managePassVM: UnlockPasscodePageManager
	private let biometricActivationContainerView = UIStackView()
	private let lineView = UIView()
	private let useFaceIdAndErrorStackView = UIStackView()
	private let useFaceIDOptionStackView = UIStackView()
	private let useFaceIDIcon = UIImageView()
	private let useFaceIDTitleLabel = PinoLabel(style: .title, text: "")
	private let useFaceIDSwitch = UISwitch()
	private let useFaceIDbetweenStackView = UIStackView()
	private let useFaceIDInfoStackView = UIStackView()
	private let keyboardview = PinoNumberPadView()

	// MARK: Public Properties

	public let passDotsView: PassDotsView

	public var hasFaceIDMode = false {
		didSet {
			setupFaceIDOptionStyles()
		}
	}

	// MARK: - Closures

	public var onSuccessUnlockClosure: (() -> Void)!
	public var onFaceIDSelected: () -> Void

	// MARK: Initializers

	init(
		managePassVM: UnlockPasscodePageManager,
		onFaceIDSelected: @escaping () -> Void
	) {
		self.managePassVM = managePassVM
		self.passDotsView = PassDotsView(passcodeManagerVM: managePassVM)
		self.onFaceIDSelected = onFaceIDSelected
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension UnlockPasscodeView {
	// MARK: Private Methods

	private func setupView() {
		topInfoContainerView.addArrangedSubview(unlockPageTitle)

		useFaceIDInfoStackView.addArrangedSubview(useFaceIDIcon)
		useFaceIDInfoStackView.addArrangedSubview(useFaceIDTitleLabel)

		useFaceIDOptionStackView.addArrangedSubview(useFaceIDInfoStackView)
		useFaceIDOptionStackView.addArrangedSubview(useFaceIDbetweenStackView)
		useFaceIDOptionStackView.addArrangedSubview(useFaceIDSwitch)

		useFaceIdAndErrorStackView.addArrangedSubview(errorLabel)
		useFaceIdAndErrorStackView.addArrangedSubview(useFaceIDOptionStackView)
		biometricActivationContainerView.addArrangedSubview(useFaceIdAndErrorStackView)
		biometricActivationContainerView.addArrangedSubview(lineView)

		useFaceIDSwitch.addTarget(self, action: #selector(onUseFaceIDSwitchChange), for: .valueChanged)

		addSubview(topInfoContainerView)
		addSubview(biometricActivationContainerView)
		addSubview(passDotsView)
		addSubview(keyboardview)
	}

	private func setupStyle() {
		biometricActivationContainerView.axis = .vertical
		biometricActivationContainerView.spacing = 16

		lineView.backgroundColor = .Pino.background

		useFaceIDInfoStackView.axis = .horizontal
		useFaceIDInfoStackView.spacing = 4

		backgroundColor = .Pino.secondaryBackground

		topInfoContainerView.axis = .vertical
		topInfoContainerView.spacing = 18
		topInfoContainerView.alignment = .center

		unlockPageTitle.text = managePassVM.title
		unlockPageTitle.font = .PinoStyle.mediumTitle2

		errorLabel.isHidden = true
		errorLabel.textColor = .Pino.errorRed
		errorLabel.font = UIFont.PinoStyle.mediumTitle3

		useFaceIDOptionStackView.axis = .horizontal
		useFaceIDOptionStackView.alignment = .center
		useFaceIDOptionStackView.isHidden = true

		useFaceIdAndErrorStackView.axis = .vertical
		useFaceIdAndErrorStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		useFaceIdAndErrorStackView.isLayoutMarginsRelativeArrangement = true
	}

	private func setupFaceIDOptionStyles() {
		useFaceIDIcon.image = UIImage(named: managePassVM.useFaceIdIcon!)

		useFaceIDTitleLabel.text = managePassVM.useFaceIdTitle
		useFaceIDTitleLabel.font = .PinoStyle.mediumSubheadline

		useFaceIDSwitch.onTintColor = .Pino.green3

		useFaceIDOptionStackView.isHidden = false
	}

	@objc
	private func onUseFaceIDSwitchChange() {
		if useFaceIDSwitch.isOn {
			onFaceIDSelected()
		}
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
		useFaceIDOptionStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true

		topInfoContainerView.pin(
			.top(padding: 115),
			.horizontalEdges(padding: 16)
		)

		passDotsView.pin(
			.relative(.top, 130, to: topInfoContainerView, .bottom),
			.centerX(),
			.fixedHeight(20)
		)

		keyboardview.pin(
			.horizontalEdges(padding: 62.5),
			.bottom(to: layoutMarginsGuide, padding: 44)
		)

		lineView.pin(
			.fixedHeight(1),
			.horizontalEdges
		)

		biometricActivationContainerView.pin(
			.horizontalEdges,
			.relative(.bottom, -16, to: keyboardview, .top)
		)

		useFaceIDIcon.pin(.fixedWidth(24), .fixedHeight(24), .centerY())
	}
}

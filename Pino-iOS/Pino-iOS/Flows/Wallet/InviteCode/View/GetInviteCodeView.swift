//
//  GetInviteCodeView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/31/23.
//

import Foundation
import UIKit

class GetInviteCodeView: UIView, UITextFieldDelegate {
	// MARK: - Closures

	private let dismissViewClosure: () -> Void

	// MARK: - Private Properties

	private let getInviteCodeVM: GetInviteCodeViewModel
	private let clearNavigationBar = ClearNavigationBar()
	private let navigationDismissButton = UIButton()
	private let navigationBarRightSideView = UIView()
	private let titleImageView = UIImageView()
	private let mainStackView = UIStackView()
	private let textsStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let getCodeButton = PinoButton(style: .active)

	// MARK: - Initializers

	init(getInviteCodeVM: GetInviteCodeViewModel, dismissViewClosure: @escaping () -> Void) {
		self.getInviteCodeVM = getInviteCodeVM
		self.dismissViewClosure = dismissViewClosure

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		navigationDismissButton.addTarget(self, action: #selector(onDismissSelf), for: .touchUpInside)

		navigationBarRightSideView.addSubview(navigationDismissButton)

		getCodeButton.addTarget(self, action: #selector(openPinoSocialPage), for: .touchUpInside)

		clearNavigationBar.setRightSectionView(view: navigationBarRightSideView)

		textsStackView.addArrangedSubview(titleLabel)
		textsStackView.addArrangedSubview(descriptionLabel)

		mainStackView.addArrangedSubview(titleImageView)
		mainStackView.addArrangedSubview(textsStackView)

		addSubview(clearNavigationBar)
		addSubview(mainStackView)
		addSubview(getCodeButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		navigationDismissButton.setImage(UIImage(named: getInviteCodeVM.navbarDismissImageName), for: .normal)

		titleImageView.image = UIImage(named: getInviteCodeVM.titleImageName)

		mainStackView.axis = .vertical
		mainStackView.spacing = 85
		mainStackView.alignment = .center

		textsStackView.axis = .vertical
		textsStackView.alignment = .center
		textsStackView.spacing = 16

		titleLabel.text = getInviteCodeVM.titleText
		titleLabel.textAlignment = .center

		descriptionLabel.text = getInviteCodeVM.descriptionText
		descriptionLabel.textAlignment = .center

		getCodeButton.setImage(UIImage(named: getInviteCodeVM.getCodeButtonImageName), for: .normal)
		var getCodeButtonConfiguration = UIButton.Configuration.filled()
		getCodeButtonConfiguration.imagePadding = 10
		getCodeButtonConfiguration.background.backgroundColor = .Pino.label
		let attributedTitle = AttributedString(getInviteCodeVM.getCodeButtonText)
		getCodeButtonConfiguration.attributedTitle = attributedTitle
		getCodeButtonConfiguration.attributedTitle?.font = .PinoStyle.semiboldBody
		getCodeButtonConfiguration.attributedTitle?.foregroundColor = .Pino.secondaryBackground
		getCodeButton.configuration = getCodeButtonConfiguration
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
		descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 317).isActive = true

		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		navigationDismissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		titleImageView.pin(.fixedWidth(238), .fixedHeight(134))
		mainStackView.pin(.relative(.top, 128, to: clearNavigationBar, .bottom), .horizontalEdges(padding: 16))
		getCodeButton.pin(.horizontalEdges(padding: 16), .bottom(to: layoutMarginsGuide, padding: 12))
	}

	@objc
	private func openPinoSocialPage() {
		let url = URL(string: getInviteCodeVM.pinoXURL)!
		UIApplication.shared.open(url)
	}

	@objc
	private func onDismissSelf() {
		dismissViewClosure()
	}
}

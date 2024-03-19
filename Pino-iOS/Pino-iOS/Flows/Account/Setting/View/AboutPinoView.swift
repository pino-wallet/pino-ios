//
//  AboutPinoView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

import UIKit

class AboutPinoView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let logoStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let logoBackgroundView = UIView()
	private let pinoLogo = UIImageView()
	private let pinoName = UILabel()
	private let pinoAppVersion = UILabel()
	private let pinoInfoCardView = UIView()
	private let pinoInfoStackView = UIStackView()
	private let termsOfServiceStackView = UIStackView()
	private let privacyPolicyStackView = UIStackView()
	private let websiteStackView = UIStackView()
	private let termsOfServiceTitle = UILabel()
	private let privacyPolicyTitle = UILabel()
	private let web3TextField = UITextField() // For debugging purposes
	private let websiteTitle = UILabel()
	private let separatorLines = [UIView(), UIView()]
	private let detailIcons = [UIImageView(), UIImageView(), UIImageView()]
	private var aboutPinoVM: AboutPinoViewModel

	// MARK: - Public Properties

	public static var web3URL: String?

	// MARK: - Initializers

	init(aboutPinoVM: AboutPinoViewModel) {
		self.aboutPinoVM = aboutPinoVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupTapGestures()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupTapGestures() {
		let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(showHiddenWeb3Provider))
		holdGesture.minimumPressDuration = 3
		termsOfServiceStackView.addGestureRecognizer(holdGesture)
		termsOfServiceStackView.isUserInteractionEnabled = true
	}

	private func setupView() {
		contentStackView.addArrangedSubview(logoStackView)
		contentStackView.addArrangedSubview(pinoInfoCardView)
		logoStackView.addArrangedSubview(logoBackgroundView)
		logoStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(pinoName)
		titleStackView.addArrangedSubview(pinoAppVersion)
		logoBackgroundView.addSubview(pinoLogo)
		pinoInfoCardView.addSubview(pinoInfoStackView)
		termsOfServiceStackView.addArrangedSubview(termsOfServiceTitle)
		termsOfServiceStackView.addArrangedSubview(detailIcons[0])
		privacyPolicyStackView.addArrangedSubview(privacyPolicyTitle)
		privacyPolicyStackView.addArrangedSubview(detailIcons[1])
		websiteStackView.addArrangedSubview(websiteTitle)
		websiteStackView.addArrangedSubview(detailIcons[2])
		pinoInfoStackView.addArrangedSubview(termsOfServiceStackView)
		pinoInfoStackView.addArrangedSubview(separatorLines[0])
		pinoInfoStackView.addArrangedSubview(privacyPolicyStackView)
		pinoInfoStackView.addArrangedSubview(separatorLines[1])
		pinoInfoStackView.addArrangedSubview(websiteStackView)
		addSubview(contentStackView)
		addSubview(web3TextField)

		termsOfServiceStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTermsOfServices)))
		privacyPolicyStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPrivacyPolicy)))
		websiteStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showWebsite)))
	}

	private func setupStyle() {
		pinoName.text = aboutPinoVM.name
		pinoAppVersion.text = aboutPinoVM.version
		termsOfServiceTitle.text = "Terms of service"
		privacyPolicyTitle.text = "Privacy policy"
		websiteTitle.text = "Visit website"
		pinoLogo.image = UIImage(named: aboutPinoVM.logo)
		pinoLogo.contentMode = .center
		for detailIcon in detailIcons {
			detailIcon.image = UIImage(named: "chevron_right")
			detailIcon.contentMode = .left
			detailIcon.tintColor = .Pino.gray3
		}

		backgroundColor = .Pino.background
		logoBackgroundView.backgroundColor = .Pino.primary
		pinoInfoCardView.backgroundColor = .Pino.secondaryBackground
		for line in separatorLines {
			line.backgroundColor = .Pino.gray3
		}

		pinoName.textColor = .Pino.green6
		pinoAppVersion.textColor = .Pino.label
		termsOfServiceTitle.textColor = .Pino.label
		privacyPolicyTitle.textColor = .Pino.label
		websiteTitle.textColor = .Pino.label

		pinoName.font = .PinoStyle.semiboldTitle1
		pinoAppVersion.font = .PinoStyle.regularCallout
		termsOfServiceTitle.font = .PinoStyle.mediumBody
		privacyPolicyTitle.font = .PinoStyle.mediumBody
		websiteTitle.font = .PinoStyle.mediumBody

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical
		pinoInfoStackView.axis = .vertical
		logoStackView.axis = .vertical

		contentStackView.spacing = 44
		titleStackView.spacing = 12
		pinoInfoStackView.spacing = 12
		logoStackView.spacing = 16

		contentStackView.alignment = .center
		titleStackView.alignment = .center
		logoStackView.alignment = .center

		logoBackgroundView.layer.cornerRadius = 12
		pinoInfoCardView.layer.cornerRadius = 12
	}

	private func setupContstraint() {
		// web3TextField is for debugging purposes
		// Is not visible in UI
		web3TextField.pin(
			.top(to: layoutMarginsGuide, padding: 0),
			.leading(to: layoutMarginsGuide, padding: 0),
			.fixedWidth(300),
			.fixedHeight(50)
		)
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 40),
			.horizontalEdges(padding: 16)
		)
		pinoLogo.pin(
			.fixedWidth(60),
			.fixedHeight(60),
			.allEdges(padding: 10)
		)
		pinoInfoStackView.pin(
			.leading(padding: 16),
			.trailing,
			.verticalEdges(padding: 12)
		)
		pinoInfoCardView.pin(
			.horizontalEdges()
		)
		for line in separatorLines {
			line.pin(
				.fixedHeight(1 / UIScreen.main.scale)
			)
		}
		for detailIcon in detailIcons {
			detailIcon.pin(
				.fixedHeight(24),
				.fixedWidth(32),
				.trailing(padding: 12)
			)
		}
	}

	@objc
	private func showHiddenWeb3Provider() {
		web3TextField.delegate = self
		web3TextField.autocorrectionType = .no
		web3TextField.autocapitalizationType = .none
		web3TextField.becomeFirstResponder()
	}

	@objc
	private func showTermsOfServices() {
		let url = URL(string: aboutPinoVM.termsOfServiceURL)
		UIApplication.shared.open(url!)
	}

	@objc
	private func showPrivacyPolicy() {
		let url = URL(string: aboutPinoVM.privacyPolicyURL)
		UIApplication.shared.open(url!)
	}

	@objc
	private func showWebsite() {
		let url = URL(string: aboutPinoVM.websiteURL)
		UIApplication.shared.open(url!)
	}
}

extension AboutPinoView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		AboutPinoView.web3URL = textField.text
		return true
	}
}

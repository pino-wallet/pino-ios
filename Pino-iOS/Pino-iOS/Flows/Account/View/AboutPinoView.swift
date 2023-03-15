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
	private let pinoName = PinoLabel(style: .title, text: nil)
	private let pinoAppVersion = PinoLabel(style: .description, text: nil)
	private let pinoInfoStackView = UIStackView()
	private var allDoneVM: AllDoneViewModel

	// MARK: - Initializers

	init(aboutPinoVM: AllDoneViewModel, getStarted: @escaping (() -> Void)) {
		self.allDoneVM = aboutPinoVM
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
		contentStackView.addArrangedSubview(logoStackView)
		contentStackView.addArrangedSubview(pinoInfoStackView)
		logoStackView.addArrangedSubview(logoBackgroundView)
		logoStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(pinoName)
		titleStackView.addArrangedSubview(pinoAppVersion)
		logoBackgroundView.addSubview(pinoLogo)
		addSubview(contentStackView)
	}

	private func setupStyle() {
		pinoLogo.image = UIImage(named: allDoneVM.image)

		pinoName.text = allDoneVM.title
		pinoAppVersion.text = allDoneVM.description

		backgroundColor = .Pino.background
		logoBackgroundView.backgroundColor = .Pino.primary

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical
		pinoInfoStackView.axis = .vertical
		logoStackView.axis = .vertical

		contentStackView.spacing = 26
		titleStackView.spacing = 8
		pinoInfoStackView.spacing = 0
		logoStackView.spacing = 18

		contentStackView.alignment = .center
		titleStackView.alignment = .center
		logoStackView.alignment = .center

		logoBackgroundView.layer.cornerRadius = 12
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 40),
			.horizontalEdges(padding: 16)
		)
		pinoLogo.pin(
			.fixedWidth(70),
			.fixedHeight(70),
			.allEdges(padding: 5)
		)
	}
}

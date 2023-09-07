//
//  AmountHealthScoreView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import UIKit

class AmountHealthScoreView: UIView {
	// MARK: - Public Properties

	public var prevHealthScore: Double = 0 {
		didSet {
			prevHealthScoreLabel.text = prevHealthScore.description
			prevHealthScoreLabel.textColor = getHealthScoreColor(healthScore: prevHealthScore)
		}
	}

	public var newHealthScore: Double = 0 {
		didSet {
			newHealthScoreLabel.text = newHealthScore.description
			newHealthScoreLabel.textColor = getHealthScoreColor(healthScore: newHealthScore)
		}
	}

	// MARK: - Private Properties

	private let containerView = PinoContainerCard(cornerRadius: 8)
	private let mainStackView = UIStackView()
	private let healthScoreTitleLabel = PinoLabel(style: .info, text: "")
	private let spacerView = UIView()
	private let healthScoreStackView = UIStackView()
	private let prevHealthScoreLabel = PinoLabel(style: .info, text: "")
	private let rightArrowImageView = UIImageView()
	private let newHealthScoreLabel = PinoLabel(style: .info, text: "")

	// MARK: - Initializers

	init() {
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
		healthScoreStackView.addArrangedSubview(prevHealthScoreLabel)
		healthScoreStackView.addArrangedSubview(rightArrowImageView)
		healthScoreStackView.addArrangedSubview(newHealthScoreLabel)

		mainStackView.addArrangedSubview(healthScoreTitleLabel)
		mainStackView.addArrangedSubview(spacerView)
		mainStackView.addArrangedSubview(healthScoreStackView)

		containerView.addSubview(mainStackView)

		addSubview(containerView)
	}

	private func setupStyles() {
		mainStackView.axis = .horizontal
		mainStackView.alignment = .center

		healthScoreStackView.axis = .horizontal
		healthScoreStackView.spacing = 4
		healthScoreStackView.alignment = .center

		healthScoreTitleLabel.text = "Health score"

		rightArrowImageView.image = UIImage(named: "right_arrow_green3")
	}

	private func setupConstraints() {
		mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		rightArrowImageView.pin(.fixedWidth(18), .fixedHeight(18))
		mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 9))
		containerView.pin(.allEdges(padding: 0))
	}

	private func getHealthScoreColor(healthScore: Double) -> UIColor {
		if healthScore == 0 {
			return .Pino.red
		} else if healthScore > 0 && healthScore < 10 {
			return .Pino.orange
		} else {
			return .Pino.green
		}
	}
}

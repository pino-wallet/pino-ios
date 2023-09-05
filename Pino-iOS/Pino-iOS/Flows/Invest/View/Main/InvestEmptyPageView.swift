//
//  InvestEmptyPageView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/5/23.
//

import UIKit

class InvestEmptyPageView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let chartIconBackgroundView = UIView()
	private let chartImageView = UIImageView()
	private let emptyPageTitleLabel = UILabel()
	private let startInvestingButton = UIButton()
	private var startInvestingDidTap: () -> Void

	// MARK: Initializers

	init(
		startInvestingDidTap: @escaping () -> Void
	) {
		self.startInvestingDidTap = startInvestingDidTap
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
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(chartIconBackgroundView)
		contentStackView.addArrangedSubview(emptyPageTitleLabel)
		contentStackView.addArrangedSubview(startInvestingButton)
		chartIconBackgroundView.addSubview(chartImageView)
	}

	private func setupStyle() {
		emptyPageTitleLabel.text = "Earn from yielding opportunities"
		startInvestingButton.setTitle("Start investing", for: .normal)
		startInvestingButton.setImage(UIImage(named: "arrow_right"), for: .normal)
		chartImageView.image = UIImage(named: "invest_tab_fill")

		emptyPageTitleLabel.font = .PinoStyle.mediumCallout
		startInvestingButton.setConfiguraton(
			font: .PinoStyle.semiboldCallout!,
			imagePadding: 4,
			imagePlacement: .trailing
		)

		emptyPageTitleLabel.textColor = .Pino.secondaryLabel
		chartImageView.tintColor = .Pino.primary
		startInvestingButton.setTitleColor(.Pino.white, for: .normal)
		startInvestingButton.tintColor = .Pino.white

		backgroundColor = .Pino.background
		chartIconBackgroundView.backgroundColor = .Pino.green1
		startInvestingButton.backgroundColor = .Pino.primary

		contentStackView.axis = .vertical
		contentStackView.alignment = .center
		contentStackView.spacing = 22

		chartImageView.contentMode = .scaleAspectFit
		chartIconBackgroundView.layer.cornerRadius = 36
		startInvestingButton.layer.cornerRadius = 8
	}

	private func setupContstraint() {
		contentStackView.pin(
			.centerX,
			.centerY
		)
		chartImageView.pin(
			.allEdges(padding: 20)
		)
		chartIconBackgroundView.pin(
			.fixedWidth(72),
			.fixedHeight(72)
		)
		startInvestingButton.pin(
			.fixedWidth(160),
			.fixedHeight(40)
		)
	}
}

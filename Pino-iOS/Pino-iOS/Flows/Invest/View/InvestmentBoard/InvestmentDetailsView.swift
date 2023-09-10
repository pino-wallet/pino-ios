//
//  InvestmentDetailsView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/10/23.
//

import UIKit

class InvestmentDeatilsView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let tokenCardView = PinoContainerCard()
	private let investInfoCardView = PinoContainerCard()
	private let tokenStackView = UIStackView()
	private let tokenImageView = UIImageView()
	private let tokenAmountStackView = UIStackView()
	private let assetAmountLabel = UILabel()
	private let assetAmountInDollarLabel = UILabel()
	private let investInfoStackView = UIStackView()
	private let selectedProtocolStackView = UIStackView()
	private let feeStackView = UIStackView()
	private let apyStackView = UIStackView()
	private let investmentAmountStackView = UIStackView()
	private let totalSectionStackView = UIStackView()
	private let totalAmountSeparatorLine = UIView()
	private let totalAmountStackView = UIStackView()
	private var selectedProtocolTitleLabel = UILabel()
	private var apyTitleLabel = UILabel()
	private var investmentAmountTitleLabel = UILabel()
	private var feeTitleLabel = UILabel()
	private var totalAmountTitleLabel = UILabel()
	private let protocolInfoStackView = UIStackView()
	private let protocolImageView = UIImageView()
	private let protoclNameLabel = UILabel()
	private let selectedProtocolSpacerView = UIView()
	private let apyLabel = UILabel()
	private let investmentAmountLabel = UILabel()
	private let investmentAmountSpacerView = UIView()
	private let feeLabel = UILabel()
	private let totalAmountLabel = UILabel()
	private let investButtonsStackView = UIStackView()
	private let increaseInvestmentButton = PinoButton(style: .active)
	private let withdrawButton = PinoButton(style: .secondary)

	private let increaseInvestmentDidTap: () -> Void
	private let withdrawDidTap: () -> Void
	private let investmentDetailsVM: InvestmentDetailViewModel!

	// MARK: - Initializers

	init(
		investmentDetailsVM: InvestmentDetailViewModel,
		increaseInvestmentDidTap: @escaping () -> Void,
		withdrawDidTap: @escaping () -> Void
	) {
		self.investmentDetailsVM = investmentDetailsVM
		self.increaseInvestmentDidTap = increaseInvestmentDidTap
		self.withdrawDidTap = withdrawDidTap
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
		addSubview(contentStackview)
		addSubview(investButtonsStackView)
		contentStackview.addArrangedSubview(tokenCardView)
		contentStackview.addArrangedSubview(investInfoCardView)
		tokenCardView.addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(tokenImageView)
		tokenStackView.addArrangedSubview(tokenAmountStackView)
		tokenAmountStackView.addArrangedSubview(assetAmountInDollarLabel)
		tokenAmountStackView.addArrangedSubview(assetAmountLabel)
		investInfoCardView.addSubview(investInfoStackView)
		investInfoStackView.addArrangedSubview(selectedProtocolStackView)
		investInfoStackView.addArrangedSubview(apyStackView)
		investInfoStackView.addArrangedSubview(investmentAmountStackView)
		investInfoStackView.addArrangedSubview(feeStackView)
		investInfoStackView.addArrangedSubview(totalSectionStackView)
		selectedProtocolStackView.addArrangedSubview(selectedProtocolTitleLabel)
		selectedProtocolStackView.addArrangedSubview(selectedProtocolSpacerView)
		selectedProtocolStackView.addArrangedSubview(protocolInfoStackView)
		protocolInfoStackView.addArrangedSubview(protocolImageView)
		protocolInfoStackView.addArrangedSubview(protoclNameLabel)
		apyStackView.addArrangedSubview(apyTitleLabel)
		apyStackView.addArrangedSubview(apyLabel)
		investmentAmountStackView.addArrangedSubview(investmentAmountTitleLabel)
		investmentAmountStackView.addArrangedSubview(investmentAmountSpacerView)
		investmentAmountStackView.addArrangedSubview(investmentAmountLabel)
		feeStackView.addArrangedSubview(feeTitleLabel)
		feeStackView.addArrangedSubview(feeLabel)
		totalSectionStackView.addArrangedSubview(totalAmountSeparatorLine)
		totalSectionStackView.addArrangedSubview(totalAmountStackView)
		totalAmountStackView.addArrangedSubview(totalAmountTitleLabel)
		totalAmountStackView.addArrangedSubview(totalAmountLabel)

		investButtonsStackView.addArrangedSubview(increaseInvestmentButton)
		investButtonsStackView.addArrangedSubview(withdrawButton)

		increaseInvestmentButton.addAction(UIAction(handler: { _ in
			self.increaseInvestmentDidTap()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		assetAmountLabel.text = investmentDetailsVM.assetAmount
		assetAmountInDollarLabel.text = investmentDetailsVM.assetAmountInDollar
		protoclNameLabel.text = investmentDetailsVM.investProtocolName
		apyLabel.text = investmentDetailsVM.apyAmount
		investmentAmountLabel.text = investmentDetailsVM.investmentAmount
		feeLabel.text = investmentDetailsVM.earnedFee
		totalAmountLabel.text = investmentDetailsVM.totalInvestmentAmount

		selectedProtocolTitleLabel.text = investmentDetailsVM.selectedProtocolTitle
		apyTitleLabel.text = investmentDetailsVM.apyTitle
		investmentAmountTitleLabel.text = investmentDetailsVM.investmentAmountTitle
		feeTitleLabel.text = investmentDetailsVM.feeTitle
		totalAmountTitleLabel.text = investmentDetailsVM.totalAmountTitle
		increaseInvestmentButton.title = investmentDetailsVM.increaseInvestmentButtonTitle
		withdrawButton.title = investmentDetailsVM.withdrawButtonTitle

		protocolImageView.image = UIImage(named: investmentDetailsVM.investProtocolImage)

		tokenImageView.kf.indicatorType = .activity
		tokenImageView.kf.setImage(with: investmentDetailsVM.assetImage)

		assetAmountInDollarLabel.font = .PinoStyle.semiboldTitle2
		assetAmountLabel.font = .PinoStyle.mediumBody
		selectedProtocolTitleLabel.font = .PinoStyle.mediumBody
		apyTitleLabel.font = .PinoStyle.mediumBody
		investmentAmountTitleLabel.font = .PinoStyle.mediumBody
		feeTitleLabel.font = .PinoStyle.mediumBody
		totalAmountTitleLabel.font = .PinoStyle.mediumBody
		protoclNameLabel.font = .PinoStyle.mediumBody
		apyLabel.font = .PinoStyle.mediumBody
		investmentAmountLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		totalAmountLabel.font = .PinoStyle.mediumBody

		assetAmountInDollarLabel.textColor = .Pino.label
		assetAmountLabel.textColor = .Pino.secondaryLabel
		selectedProtocolTitleLabel.textColor = .Pino.secondaryLabel
		apyTitleLabel.textColor = .Pino.secondaryLabel
		investmentAmountTitleLabel.textColor = .Pino.secondaryLabel
		feeTitleLabel.textColor = .Pino.secondaryLabel
		totalAmountTitleLabel.textColor = .Pino.label
		protoclNameLabel.textColor = .Pino.label
		investmentAmountLabel.textColor = .Pino.label
		totalAmountLabel.textColor = .Pino.label

		switch investmentDetailsVM.investVolatilityType {
		case .profit:
			apyLabel.textColor = .Pino.green
			feeLabel.textColor = .Pino.green
		case .loss:
			apyLabel.textColor = .Pino.red
			feeLabel.textColor = .Pino.red
		case .none:
			apyLabel.textColor = .Pino.label
			feeLabel.textColor = .Pino.label
		}

		backgroundColor = .Pino.background
		totalAmountSeparatorLine.backgroundColor = .Pino.gray5

		feeLabel.textAlignment = .right

		tokenStackView.axis = .vertical
		tokenAmountStackView.axis = .vertical
		investInfoStackView.axis = .vertical
		contentStackview.axis = .vertical
		investButtonsStackView.axis = .vertical
		totalSectionStackView.axis = .vertical

		tokenStackView.alignment = .center
		tokenAmountStackView.alignment = .center
		protocolInfoStackView.alignment = .center

		contentStackview.spacing = 16
		tokenStackView.spacing = 20
		tokenAmountStackView.spacing = 10
		investInfoStackView.spacing = 22
		totalSectionStackView.spacing = 18
		protocolInfoStackView.spacing = 4
		investButtonsStackView.spacing = 16

		tokenImageView.layer.cornerRadius = 25
		tokenImageView.layer.masksToBounds = true
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 25)
		)
		tokenStackView.pin(
			.allEdges(padding: 16)
		)
		investInfoStackView.pin(
			.horizontalEdges(padding: 14),
			.top(padding: 20),
			.bottom(padding: 18)
		)
		investButtonsStackView.pin(
			.bottom(to: layoutMarginsGuide, padding: 4),
			.horizontalEdges(padding: 16)
		)
		tokenImageView.pin(
			.fixedWidth(50),
			.fixedHeight(50)
		)
		protocolImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		totalAmountSeparatorLine.pin(
			.fixedHeight(1)
		)
	}
}

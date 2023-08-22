//
//  InvestmentRiskPerformanceView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/22/23.
//

import UIKit

class InvestmentRiskPerformanceView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let tokenStackView = UIStackView()
	private let tokenImageView = UIImageView()
	private let tokenNameLabel = UILabel()
	private let riskView = UIView()
	private let riskTitleLabel = UILabel()
	private let protocolCardView = UIView()
	private let protocolStackView = UIStackView()
	private let protocolImageStackView = UIStackView()
	private let protocolImageView = UIImageView()
	private let protocolTitleStackView = UIStackView()
	private let protocolNameLabel = UILabel()
	private let protocolTitleLabel = UILabel()
	private let protocolDescriptionLabel = UILabel()
	private let risksTitleLabel = UILabel()
	private let risksStackview = UIStackView()
	private let risksInfoCardView = UIView()
	private let risksInfoStackView = UIStackView()

	private let assetVM: InvestableAssetViewModel

	// MARK: - Initializers

	init(assetVM: InvestableAssetViewModel, viewDidDissmiss: @escaping () -> Void) {
		self.assetVM = assetVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(tokenStackView)
		contentStackView.addArrangedSubview(protocolCardView)
		contentStackView.addArrangedSubview(risksStackview)

		tokenStackView.addArrangedSubview(tokenImageView)
		tokenStackView.addArrangedSubview(tokenNameLabel)
		tokenStackView.addArrangedSubview(riskView)

		protocolCardView.addSubview(protocolStackView)
		protocolStackView.addArrangedSubview(protocolImageStackView)
		protocolStackView.addArrangedSubview(protocolDescriptionLabel)
		protocolImageStackView.addArrangedSubview(protocolImageView)
		protocolImageStackView.addArrangedSubview(protocolTitleStackView)
		protocolTitleStackView.addArrangedSubview(protocolNameLabel)
		protocolTitleStackView.addArrangedSubview(protocolTitleLabel)

		risksStackview.addArrangedSubview(risksTitleLabel)
		risksStackview.addArrangedSubview(risksInfoCardView)
		risksInfoCardView.addSubview(risksInfoStackView)
		setupRiskInfoView()
	}

	private func setupStyle() {
		tokenNameLabel.text = assetVM.assetName
		riskTitleLabel.text = "High risk"
		protocolNameLabel.text = assetVM.assetProtocol.protocolInfo.name
		protocolDescriptionLabel
			.text =
			"\(assetVM.assetProtocol.protocolInfo.name) is a DEX enabling users to supply liquidity and earn trade fees in return."

		protocolImageView.image = UIImage(named: assetVM.protocolImage)
		tokenImageView.kf.indicatorType = .activity
		tokenImageView.kf.setImage(with: assetVM.assetImage)

		backgroundColor = .Pino.secondaryBackground
	}

	private func setupContstraint() {}

	private func setupRiskInfoView() {
		let risksInfo = ["Higher fee collection", "Principal value volatility", "Impermanent loss"]
		for riskInfo in risksInfo {
			let riskInfoView = riskInfoItemView()
			riskInfoView.riskInfo = riskInfo
			riskInfoView.riskColor = .Pino.orange
			risksInfoStackView.addArrangedSubview(riskInfoView)
		}
	}
}

class riskInfoItemView: UIStackView {
	// MARK: - Private Properties

	private let riskColorView = UIView()
	private let riskInfoLabel = UILabel()

	// MARK: - Public Properties

	public var riskInfo: String! {
		didSet {
			riskInfoLabel.text = riskInfo
		}
	}

	public var riskColor: UIColor! {
		didSet {
			riskColorView.backgroundColor = riskColor
		}
	}

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addArrangedSubview(riskColorView)
		addArrangedSubview(riskInfoLabel)
	}

	private func setupStyle() {
		riskInfoLabel.font = .PinoStyle.mediumCallout
		riskInfoLabel.textColor = .Pino.label

		spacing = 6
	}

	private func setupConstraint() {
		riskColorView.pin(
			.fixedWidth(8),
			.fixedHeight(8)
		)
	}
}

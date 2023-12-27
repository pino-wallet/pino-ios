//
//  CoinInfoStatsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/16/23.
//

import UIKit

class CoinInfoStatsView: UIStackView {
	// MARK: - Public Properties

	public var coinInfoVM: CoinInfoViewModel! {
		didSet {
			setupStyles()
			setupStylesFromCoinType()
			setupTapGesturesByCoinType()
		}
	}

	// MARK: - Private Properties

	private let firstStatStackView = UIStackView()
	private let secondStatStackView = UIStackView()
	private let thirdStatStackView = UIStackView()
	private let firstStatInfoStackView = UIStackView()
	private let secondStatInfoStackView = UIStackView()
	private let thirdStatInfoStackView = UIStackView()
	private let firstTitleLabel = PinoLabel(style: .title, text: "")
	private let secondTitleLabel = PinoLabel(style: .title, text: "")
	private let thirdTitleLabel = PinoLabel(style: .title, text: "")
	private let firstStatLabel = PinoLabel(style: .title, text: "")
	private let secondStatLabel = PinoLabel(style: .title, text: "")
	private let thirdStatLabel = PinoLabel(style: .title, text: "")
	private let coinPriceStackView = UIStackView()
	private let coinPriceStackViewSepratorLabel = PinoLabel(style: .title, text: "")
	private let coinPriceChangeLabel = PinoLabel(style: .title, text: "")
	private let coinPriceLabel = PinoLabel(style: .title, text: "")
	private var websiteTapGesture: UITapGestureRecognizer!
	private var contractAddressGesture: UITapGestureRecognizer!

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupConstraints()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		firstStatInfoStackView.addArrangedSubview(firstTitleLabel)

		secondStatInfoStackView.addArrangedSubview(secondTitleLabel)

		thirdStatInfoStackView.addArrangedSubview(thirdTitleLabel)

		firstStatStackView.addArrangedSubview(firstStatInfoStackView)
		firstStatStackView.addArrangedSubview(firstStatLabel)

		secondStatStackView.addArrangedSubview(secondStatInfoStackView)
		secondStatStackView.addArrangedSubview(secondStatLabel)

		coinPriceStackView.addArrangedSubview(coinPriceLabel)
		coinPriceStackView.addArrangedSubview(coinPriceStackViewSepratorLabel)
		coinPriceStackView.addArrangedSubview(coinPriceChangeLabel)

		thirdStatStackView.addArrangedSubview(thirdStatInfoStackView)
		thirdStatStackView.addArrangedSubview(thirdStatLabel)
		thirdStatStackView.addArrangedSubview(coinPriceStackView)

		[firstStatStackView, secondStatStackView, thirdStatStackView].forEach {
			addArrangedSubview($0)
		}
	}

	private func setupTapGesturesByCoinType() {
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			setupTapGestures()
		case .unVerified:
			setupTapGestures()
		case .position:
			return
		}
	}

	private func setupTapGestures() {
		websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyWebsite))
		contractAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyContractAddress))
		firstStatLabel.isUserInteractionEnabled = true
		secondStatLabel.isUserInteractionEnabled = true
		secondStatLabel.addGestureRecognizer(contractAddressGesture)
		firstStatLabel.addGestureRecognizer(websiteTapGesture)
	}

	private func setupStyles() {
		axis = .vertical
		spacing = 30
		distribution = .fillEqually

		[firstStatStackView, secondStatStackView, thirdStatStackView].forEach {
			$0.axis = .horizontal
			$0.spacing = 8
			$0.distribution = .equalCentering
		}

		[firstStatInfoStackView, secondStatInfoStackView, thirdStatInfoStackView].forEach {
			$0.axis = .horizontal
			$0.spacing = 2
			$0.alignment = .center
		}

		[firstTitleLabel, secondTitleLabel, thirdTitleLabel].forEach {
			$0.font = .PinoStyle.mediumBody
			$0.textColor = .Pino.secondaryLabel
		}

		[firstStatLabel, secondStatLabel, thirdStatLabel].forEach {
			$0.font = .PinoStyle.mediumBody
			$0.textColor = .Pino.label
		}

		coinPriceStackView.axis = .horizontal
		coinPriceStackView.spacing = 3

		coinPriceChangeLabel.font = .PinoStyle.mediumBody

		coinPriceStackViewSepratorLabel.font = .PinoStyle.mediumBody
		coinPriceStackViewSepratorLabel.textColor = .Pino.gray4
		coinPriceStackViewSepratorLabel.text = coinInfoVM.priceSepratorText

		coinPriceLabel.font = .PinoStyle.mediumBody

		firstTitleLabel.text = coinInfoVM.websiteTitle
		secondTitleLabel.text = coinInfoVM.contractAddressTitle
		thirdTitleLabel.text = coinInfoVM.priceTitle
	}

	private func setupStylesFromCoinType() {
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			thirdStatLabel.isHidden = true
			coinPriceStackView.isHidden = false

			firstStatLabel.text = coinInfoVM.coinPortfolio.website

			secondStatLabel.text = coinInfoVM.coinPortfolio.formattedContractAddress

			coinPriceLabel.text = coinInfoVM.coinPortfolio.price

			coinPriceChangeLabel.text = coinInfoVM.coinPortfolio.volatilityRatePercentage

			switch coinInfoVM.coinPortfolio.volatilityType {
			case .profit:
				coinPriceChangeLabel.textColor = .Pino.green
			case .loss:
				coinPriceChangeLabel.textColor = .Pino.red
			case .none:
				coinPriceChangeLabel.textColor = .Pino.secondaryLabel
			}

		case .unVerified:
			coinPriceStackView.isHidden = true
			thirdStatLabel.isHidden = false

			thirdStatLabel.text = coinInfoVM.noAssetPriceText

			firstStatLabel.text = coinInfoVM.coinPortfolio.website

			secondStatLabel.text = coinInfoVM.coinPortfolio.formattedContractAddress

		case .position:
			firstTitleLabel.text = coinInfoVM.protocolTitle
			secondTitleLabel.text = coinInfoVM.positionTitle
			thirdTitleLabel.text = coinInfoVM.assetTitle

			coinPriceStackView.isHidden = true
			thirdStatLabel.isHidden = false
			#warning("this section should be updated after connect app to position assets")
		}

		[firstStatLabel, secondStatLabel, thirdStatLabel].forEach {
			$0.numberOfLines = 1
			$0.lineBreakMode = .byTruncatingTail
			$0.textAlignment = .right
		}
	}

	private func setupConstraints() {
		[firstStatLabel, secondStatLabel, thirdStatLabel].forEach {
			$0.widthAnchor.constraint(greaterThanOrEqualToConstant: 57).isActive = true
		}
	}

	@objc
	private func copyWebsite() {
		let pasteBoard = UIPasteboard.general
		pasteBoard.string = coinInfoVM.coinPortfolio.website

		Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
	}

	@objc
	private func copyContractAddress() {
		if !coinInfoVM.coinPortfolio.isEthCoin {
			let pasteBoard = UIPasteboard.general
			pasteBoard.string = coinInfoVM.coinPortfolio.contractAddress

			Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
		}
	}
}

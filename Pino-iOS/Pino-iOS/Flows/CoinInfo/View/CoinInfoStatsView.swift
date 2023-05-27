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
			setupTapGestures()
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
	private let copyToastview = PinoToastView(message: nil, style: .primary)
	private var websiteTapGesture: UITapGestureRecognizer!
	private var contractAddressGesture: UITapGestureRecognizer!

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
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
			$0.isSkeletonable = true
		}

		[firstStatLabel, secondStatLabel, thirdStatLabel].forEach {
			$0.font = .PinoStyle.mediumBody
			$0.textColor = .Pino.label
			$0.isSkeletonable = true
		}

		coinPriceStackView.axis = .horizontal
		coinPriceStackView.spacing = 3
		coinPriceStackView.isSkeletonable = true

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

			secondStatLabel.text = coinInfoVM.coinPortfolio.contractAddress
			secondStatLabel.lineBreakMode = .byTruncatingMiddle
			setupSecondStatLabelConstraint()

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

			secondStatLabel.text = coinInfoVM.coinPortfolio.contractAddress
			secondStatLabel.lineBreakMode = .byTruncatingMiddle
			setupSecondStatLabelConstraint()

		case .position:
			firstTitleLabel.text = coinInfoVM.protocolTitle
			secondTitleLabel.text = coinInfoVM.positionTitle
			thirdTitleLabel.text = coinInfoVM.assetTitle

			coinPriceStackView.isHidden = true
			thirdStatLabel.isHidden = false
			#warning("this section should be updated after connect app to position assets")
		}
	}

	private func setupTapGestures() {
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyWebsite))
			contractAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyContractAddress))
			firstStatLabel.isUserInteractionEnabled = true
			secondStatLabel.isUserInteractionEnabled = true
			secondStatLabel.addGestureRecognizer(contractAddressGesture)
			firstStatLabel.addGestureRecognizer(websiteTapGesture)
		case .unVerified:
			websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyWebsite))
			contractAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyContractAddress))
			firstStatLabel.isUserInteractionEnabled = true
			secondStatLabel.isUserInteractionEnabled = true
			secondStatLabel.addGestureRecognizer(contractAddressGesture)
			firstStatLabel.addGestureRecognizer(websiteTapGesture)
		case .position:
			return
		}
	}

	private func setupSecondStatLabelConstraint() {
		secondStatLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
	}

	@objc
	private func copyWebsite() {
		let pasteBoard = UIPasteboard.general
		pasteBoard.string = coinInfoVM.coinPortfolio.website

		copyToastview.message = coinInfoVM.copyWebsiteToastText
		copyToastview.showToast()
	}

	@objc
	private func copyContractAddress() {
		if !coinInfoVM.coinPortfolio.isEthCoin {
			let pasteBoard = UIPasteboard.general
			pasteBoard.string = coinInfoVM.coinPortfolio.contractAddress

			copyToastview.message = coinInfoVM.copyContractAddressToastText
			copyToastview.showToast()
		}
	}
}

//
//  InvestmentPerformanceAssetCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import UIKit

class InvestmentPerformanceAssetCell: GroupCollectionViewCell {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let progressStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let amountStackView = UIStackView()
	private let assetName = UILabel()
	private let assetAmount = UILabel()
	private let assetAmountPercentage = UILabel()
	private let progressView = UIProgressView()
	private var assetImage: InvestAssetImageView!

	// MARK: Public Properties

	public static let cellReuseID = "investmentPerformanceCell"

	public var assetVM: ShareOfAssetsProtocol! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		assetImage = InvestAssetImageView(assetImage: assetVM.assetImage, protocolImage: assetVM.protocolImage)

		cardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(assetImage)
		contentStackView.addArrangedSubview(amountStackView)
		amountStackView.addArrangedSubview(titleStackView)
		amountStackView.addArrangedSubview(progressStackView)
		titleStackView.addArrangedSubview(assetName)
		titleStackView.addArrangedSubview(assetAmount)
		progressStackView.addArrangedSubview(progressView)
		progressStackView.addArrangedSubview(assetAmountPercentage)
	}

	private func setupStyle() {
		assetName.text = assetVM.assetName
		assetAmount.text = assetVM.assetAmount
		assetAmountPercentage.text = assetVM.amountPercentage

		let progressbarFloatValue = Float(assetVM.progressBarValue!.decimalString)!
		progressView.setProgress(progressbarFloatValue, animated: true)
		progressView.progressTintColor = .Pino.secondaryLabel
		progressView.trackTintColor = .Pino.clear

		assetName.textColor = .Pino.label
		assetAmount.textColor = .Pino.label
		assetAmountPercentage.textColor = .Pino.secondaryLabel

		assetName.font = .PinoStyle.mediumCallout
		assetAmount.font = .PinoStyle.mediumCallout
		assetAmountPercentage.font = .PinoStyle.mediumFootnote

		contentStackView.axis = .horizontal
		amountStackView.axis = .vertical
		titleStackView.axis = .horizontal
		progressStackView.axis = .horizontal

		contentStackView.spacing = 8
		progressStackView.spacing = 4
		amountStackView.spacing = 4

		titleStackView.distribution = .equalCentering
		progressStackView.distribution = .fill
		progressStackView.alignment = .center
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.centerY
		)
		progressView.pin(
			.fixedHeight(3)
		)
		assetImage.pin(
			.fixedWidth(40),
			.fixedHeight(40)
		)
	}
}
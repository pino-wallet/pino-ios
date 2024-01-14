//
//  SwapConfirmationTokenView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import UIKit

class SwapConfirmationTokenView: UIView {
	// MARK: - Private Properties

	private let tokenStackView = UIStackView()
	private let tokenInfoStackView = UIStackView()
	private let tokenImageView = UIImageView()
	private let tokenNameLabel = UILabel()
	private let tokenAmountLabel = UILabel()
	private let tokenAmountInDollar = UILabel()
	private let tokenSpacerView = UIView()

	private let swapTokenVM: SwapTokenViewModel

	// MARK: - Initializers

	init(
		swapTokenVM: SwapTokenViewModel
	) {
		self.swapTokenVM = swapTokenVM
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
		addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(tokenInfoStackView)
		tokenStackView.addArrangedSubview(tokenSpacerView)
		tokenStackView.addArrangedSubview(tokenAmountInDollar)
		tokenInfoStackView.addArrangedSubview(tokenImageView)
		tokenInfoStackView.addArrangedSubview(tokenAmountLabel)
		tokenInfoStackView.addArrangedSubview(tokenNameLabel)
	}

	private func setupStyle() {
		tokenNameLabel.text = swapTokenVM.selectedToken.symbol
		tokenAmountLabel.text = swapTokenVM.tokenAmountBigNum?.sevenDigitFormat
		tokenAmountInDollar.text = swapTokenVM.dollarAmount

		if swapTokenVM.selectedToken.isVerified {
			tokenImageView.kf.indicatorType = .activity
			tokenImageView.kf.setImage(with: swapTokenVM.selectedToken.image)
		} else {
			tokenImageView.image = UIImage(named: swapTokenVM.selectedToken.customAssetImage)
		}

		tokenNameLabel.font = .PinoStyle.mediumCallout
		tokenAmountLabel.font = .PinoStyle.semiboldTitle1
		tokenAmountInDollar.font = .PinoStyle.mediumSubheadline

		tokenNameLabel.textColor = .Pino.label
		tokenAmountLabel.textColor = .Pino.label
		tokenAmountInDollar.textColor = .Pino.secondaryLabel

		tokenStackView.spacing = 8
		tokenInfoStackView.spacing = 8

		tokenImageView.layer.cornerRadius = 20
		tokenImageView.layer.masksToBounds = true
	}

	private func setupContstraint() {
		tokenStackView.pin(
			.allEdges(padding: 14)
		)
		tokenImageView.pin(
			.fixedWidth(40),
			.fixedHeight(40)
		)
	}
}

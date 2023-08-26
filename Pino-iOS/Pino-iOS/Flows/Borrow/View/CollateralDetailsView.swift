//
//  LoanDetailsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import UIKit

class CollateralDetailsView: UIView {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let headerContainerView = PinoContainerCard()
	private let headerStackView = UIStackView()
	private let headerTitleImage = UIImageView()
	private let headerTitleLabel = PinoLabel(style: .title, text: "")
    private let headerTotalAmountInDollarsLabel = PinoLabel(style: .info, text: "")
	private let contentContainerView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let borderView = UIView()
	private let buttonsStackView = UIStackView()
	private let increaseButton = PinoButton(style: .active)
	private let withdrawButton = PinoButton(style: .secondary)
	private var involvedAmountStackView: LoanDetailsInfoStackView!
	private var freeAmountStackView: LoanDetailsInfoStackView!
	private var totalCollateralStackView: LoanDetailsInfoStackView!

	private var collateralDetailsVM: CollateralDetailsViewModel

	// MARK: - Initializers

	init(collateralDetailsVM: CollateralDetailsViewModel) {
		self.collateralDetailsVM = collateralDetailsVM

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
		involvedAmountStackView = LoanDetailsInfoStackView(titleText: collateralDetailsVM.involvedTitle, infoText: collateralDetailsVM.involvedAmountInToken)
		freeAmountStackView = LoanDetailsInfoStackView(
			titleText: collateralDetailsVM.freeTitle,
			infoText: collateralDetailsVM.freeAmountInToken
		)
		totalCollateralStackView = LoanDetailsInfoStackView(
			titleText: collateralDetailsVM.totalCollateralTitle,
			infoText: collateralDetailsVM.totalCollateral
		)

		contentContainerView.addSubview(contentStackView)

		contentStackView.addArrangedSubview(involvedAmountStackView)
		contentStackView.addArrangedSubview(freeAmountStackView)
		contentStackView.addArrangedSubview(borderView)
		contentStackView.addArrangedSubview(totalCollateralStackView)

		headerStackView.addArrangedSubview(headerTitleImage)
		headerStackView.addArrangedSubview(headerTitleLabel)
        headerStackView.addArrangedSubview(headerTotalAmountInDollarsLabel)

		headerContainerView.addSubview(headerStackView)

		mainStackView.addArrangedSubview(headerContainerView)
		mainStackView.addArrangedSubview(contentContainerView)

		buttonsStackView.addArrangedSubview(increaseButton)
		buttonsStackView.addArrangedSubview(withdrawButton)

		addSubview(mainStackView)
		addSubview(buttonsStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		totalCollateralStackView.titleLabel.textColor = .Pino.label

		totalCollateralStackView.infoLabel.font = .PinoStyle.semiboldBody

		mainStackView.axis = .vertical
		mainStackView.spacing = 16

		headerStackView.axis = .vertical
		headerStackView.spacing = 16
		headerStackView.alignment = .center
        headerStackView.setCustomSpacing(4, after: headerTitleLabel)

		headerTitleImage.image = UIImage(named: collateralDetailsVM.tokenIcon)

		headerTitleLabel.font = .PinoStyle.semiboldTitle2
		headerTitleLabel.text = collateralDetailsVM.tokenCollateralAmountAndSymbol
		headerTitleLabel.numberOfLines = 0

		contentStackView.axis = .vertical
		contentStackView.spacing = 16

		increaseButton.title = collateralDetailsVM.increaseLoanTitle

		withdrawButton.title = collateralDetailsVM.withdrawTitle

		borderView.backgroundColor = .Pino.gray5

		buttonsStackView.axis = .vertical
		buttonsStackView.spacing = 24
        
        headerTotalAmountInDollarsLabel.textColor = .Pino.secondaryLabel
        headerTotalAmountInDollarsLabel.text = collateralDetailsVM.totalTokenAmountInDollar
	}

	private func setupConstraints() {
        headerTotalAmountInDollarsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		headerTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true

		mainStackView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
		headerStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 16))
		headerTitleImage.pin(.fixedWidth(50), .fixedHeight(50))
		borderView.pin(.fixedHeight(1))
		contentStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 18))
		buttonsStackView.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: layoutMarginsGuide, padding: 20)
		)
	}
}

//
//  ActivityDetailsHeaderView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import UIKit

class ActivityDetailsHeaderView: UIView {
	// MARK: - Public Properties

	public var activityDetailsVM: ActivityDetailsViewModel
	public var isSwapMode: Bool

	// MARK: - Private Properties

	private let cardView = PinoContainerCard()
	private let defaultStackView = UIStackView()
	private let defaultImageView = UIImageView()
	private let defaultTitleLabel = PinoLabel(style: .title, text: "")
	private let swapStackView = UIStackView()
	private let fromItemStackView = UIStackView()
	private let toItemStackView = UIStackView()
	private let fromTokenAmountStackView = UIStackView()
	private let toTokenAmountStackView = UIStackView()
	private let swapIconView = UIImageView()
	private let swapIconViewContainer = UIView()
	private let fromTokenImageView = UIImageView()
	private let toTokenImageView = UIImageView()
	private let fromTokenAmountLabel = PinoLabel(style: .title, text: "")
	private let toTokenAmountLabel = PinoLabel(style: .title, text: "")
	private let fromTokenSymbolLabel = PinoLabel(style: .title, text: "")
	private let toTokenSymbolLabel = PinoLabel(style: .title, text: "")

	// MARK: - Initializers

	init(activityDetailsVM: ActivityDetailsViewModel, isSwapMode: Bool = false) {
		self.isSwapMode = isSwapMode
		self.activityDetailsVM = activityDetailsVM

		super.init(frame: .zero)

		setupViewWithSwapMode()
		setupStylesWithSwapMode()
		setupConstraintsWithSwapMode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupViewWithSwapMode() {
		if isSwapMode {
			fromTokenAmountStackView.addArrangedSubview(fromTokenAmountLabel)
			fromTokenAmountStackView.addArrangedSubview(fromTokenSymbolLabel)

			toTokenAmountStackView.addArrangedSubview(toTokenAmountLabel)
			toTokenAmountStackView.addArrangedSubview(toTokenSymbolLabel)

			fromItemStackView.addArrangedSubview(fromTokenImageView)
			fromItemStackView.addArrangedSubview(fromTokenAmountStackView)

			toItemStackView.addArrangedSubview(toTokenImageView)
			toItemStackView.addArrangedSubview(toTokenAmountStackView)

			swapIconViewContainer.addSubview(swapIconView)

			swapStackView.addArrangedSubview(fromItemStackView)
			swapStackView.addArrangedSubview(swapIconViewContainer)
			swapStackView.addArrangedSubview(toItemStackView)

			cardView.addSubview(swapStackView)
		} else {
			defaultStackView.addArrangedSubview(defaultImageView)
			defaultStackView.addArrangedSubview(defaultTitleLabel)

			cardView.addSubview(defaultStackView)
		}
		addSubview(cardView)
	}

	private func setupStylesWithSwapMode() {
		if isSwapMode {
			swapStackView.axis = .vertical
			swapStackView.alignment = .leading
			swapStackView.spacing = 12

			fromItemStackView.axis = .horizontal
			fromItemStackView.alignment = .center
			fromItemStackView.spacing = 8

			toItemStackView.axis = .horizontal
			toItemStackView.alignment = .center
			toItemStackView.spacing = 8

			fromTokenAmountStackView.axis = .horizontal
			fromTokenAmountStackView.alignment = .center
			fromTokenAmountStackView.spacing = 4

			toTokenAmountStackView.axis = .horizontal
			toTokenAmountStackView.alignment = .center
			toTokenAmountStackView.spacing = 4

			fromTokenImageView
				.image = UIImage(named: activityDetailsVM.fromTokenImageName ?? activityDetailsVM.unVerifiedAssetIconName)
			fromTokenAmountLabel.font = .PinoStyle.semiboldTitle2
			fromTokenSymbolLabel.font = .PinoStyle.mediumCallout
			fromTokenAmountLabel.text = activityDetailsVM.fromTokenAmount
			fromTokenAmountLabel.numberOfLines = 0
			fromTokenSymbolLabel.text = activityDetailsVM.fromTokenSymbol

			toTokenImageView
				.image = UIImage(named: activityDetailsVM.toTokenImageName ?? activityDetailsVM.unVerifiedAssetIconName)
			toTokenAmountLabel.font = .PinoStyle.semiboldTitle2
			toTokenSymbolLabel.font = .PinoStyle.mediumCallout
			toTokenAmountLabel.text = activityDetailsVM.toTokenAmount
			toTokenAmountLabel.numberOfLines = 0
			toTokenSymbolLabel.text = activityDetailsVM.toTokenSymbol

			swapIconView.image = UIImage(named: activityDetailsVM.swapDownArrow)
		} else {
			defaultStackView.axis = .vertical
			defaultStackView.alignment = .center
			defaultStackView.spacing = 16

			defaultTitleLabel.font = .PinoStyle.semiboldTitle2
			defaultTitleLabel.text = activityDetailsVM.assetAmountTitle ?? ""
			defaultTitleLabel.numberOfLines = 0

			defaultImageView
				.image = UIImage(named: activityDetailsVM.assetIconName ?? activityDetailsVM.unVerifiedAssetIconName)
		}
	}

	private func setupConstraintsWithSwapMode() {
		cardView.pin(.allEdges(padding: 0))
		if isSwapMode {
			cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 164).isActive = true
			toTokenAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 160).isActive = true
			fromTokenAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 160).isActive = true

			swapStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 14))
			swapIconViewContainer.pin(.fixedWidth(32), .fixedHeight(32))
			swapIconView.pin(.fixedWidth(24), .fixedHeight(24), .centerX, .centerY)
			fromTokenImageView.pin(.fixedWidth(40), .fixedHeight(40))
			toTokenImageView.pin(.fixedWidth(40), .fixedHeight(40))
		} else {
			cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 126).isActive = true

			defaultStackView.pin(.verticalEdges(padding: 16), .horizontalEdges(padding: 14))
			defaultImageView.pin(.fixedWidth(50), .fixedHeight(50))
		}
	}
}

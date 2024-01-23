//
//  ActivitySwapHeaderView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/16/23.
//

import Combine
import Kingfisher
import UIKit

class ActivitySwapHeaderView: UIView {
	// MARK: - Private Properties

	private let cardView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let activityDetailsVM: ActivityDetailsViewModel
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
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(activityDetailsVM: ActivityDetailsViewModel) {
		self.activityDetailsVM = activityDetailsVM

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		fromTokenAmountStackView.addArrangedSubview(fromTokenAmountLabel)
		fromTokenAmountStackView.addArrangedSubview(fromTokenSymbolLabel)

		toTokenAmountStackView.addArrangedSubview(toTokenAmountLabel)
		toTokenAmountStackView.addArrangedSubview(toTokenSymbolLabel)

		fromItemStackView.addArrangedSubview(fromTokenImageView)
		fromItemStackView.addArrangedSubview(fromTokenAmountStackView)

		toItemStackView.addArrangedSubview(toTokenImageView)
		toItemStackView.addArrangedSubview(toTokenAmountStackView)

		swapIconViewContainer.addSubview(swapIconView)

		mainStackView.addArrangedSubview(fromItemStackView)
		mainStackView.addArrangedSubview(swapIconViewContainer)
		mainStackView.addArrangedSubview(toItemStackView)

		addSubview(cardView)
		cardView.addSubview(mainStackView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.alignment = .leading
		mainStackView.spacing = 12

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

		fromTokenAmountLabel.font = .PinoStyle.semiboldTitle2
		fromTokenSymbolLabel.font = .PinoStyle.mediumCallout

		toTokenAmountLabel.font = .PinoStyle.semiboldTitle2
		toTokenSymbolLabel.font = .PinoStyle.mediumCallout

		swapIconView.image = UIImage(named: activityDetailsVM.swapDownArrow)
	}

	private func setupConstraints() {
		toTokenAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 160).isActive = true
		fromTokenAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 160).isActive = true
		cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 164).isActive = true

		swapIconViewContainer.pin(.fixedWidth(32), .fixedHeight(32))
		swapIconView.pin(.fixedWidth(24), .fixedHeight(24), .centerX, .centerY)
		fromTokenImageView.pin(.fixedWidth(40), .fixedHeight(40))
		toTokenImageView.pin(.fixedWidth(40), .fixedHeight(40))

		cardView.pin(.allEdges(padding: 0))
		mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 14))
	}

	private func setValues(activityProperties: ActivityDetailProperties) {
        if let fromTokenIcon = activityProperties.fromTokenIcon {
            fromTokenImageView.kf.indicatorType = .activity
            fromTokenImageView.kf.setImage(with: fromTokenIcon)
        } else {
            fromTokenImageView.image = UIImage(named: activityDetailsVM.unVerifiedAssetIconName)
        }
		fromTokenAmountLabel.text = activityProperties.fromTokenAmount
		fromTokenAmountLabel.numberOfLines = 0
		fromTokenSymbolLabel.text = activityProperties.fromTokenSymbol

        if let toTokenIcon = activityProperties.toTokenIcon {
            toTokenImageView.kf.indicatorType = .activity
            toTokenImageView.kf.setImage(with: toTokenIcon)
        } else {
            toTokenImageView.image = UIImage(named: activityDetailsVM.unVerifiedAssetIconName)
        }
		toTokenAmountLabel.text = activityProperties.toTokenAmount
		toTokenAmountLabel.numberOfLines = 0
		toTokenSymbolLabel.text = activityProperties.toTokenSymbol
	}

	private func setupBindings() {
		activityDetailsVM.$properties.sink { activityProperties in
			self.setValues(activityProperties: activityProperties!)
		}.store(in: &cancellables)
	}
}

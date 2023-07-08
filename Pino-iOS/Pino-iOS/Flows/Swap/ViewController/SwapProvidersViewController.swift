//
//  ProvidersViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import UIKit

class SwapProvidersViewcontroller: UIAlertController {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let closePageButton = PinoButton(style: .active)
	private var providersCollectionView: SwapProvidersCollectionView!

	private var providerDidSelect: ((SwapProviderModel) -> Void)!

	// MARK: - Initializers

	convenience init(providerDidSelect: @escaping (SwapProviderModel) -> Void) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)
		self.providerDidSelect = providerDidSelect
		setupView()
		setupStyle()
		setupConstraint()
	}

	// MARK: - Private Methods

	private func setupView() {
		providersCollectionView = SwapProvidersCollectionView(
			swapProviders: [
				SwapProviderModel(provider: .oneInch, swapAmount: "1,430 USDC"),
				SwapProviderModel(provider: .paraswap, swapAmount: "1,430 USDC"),
				SwapProviderModel(provider: .zeroX, swapAmount: "1,430 USDC"),
			],
			providerDidSelect: { provider in }
		)
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(providersCollectionView)
		contentStackView.addArrangedSubview(closePageButton)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle() {
		titleLabel.text = "title"
		descriptionLabel.text = "description"
		closePageButton.title = "Got it"

		contentView.backgroundColor = .Pino.secondaryBackground
		providersCollectionView.backgroundColor = .Pino.clear
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackView.spacing = 30
		titleStackView.spacing = 5

		closePageButton.addAction(UIAction(handler: { _ in
			self.dismiss(animated: true)
		}), for: .touchUpInside)
	}

	private func setupConstraint() {
		contentStackView.pin(
			.allEdges(padding: 16)
		)
		contentView.pin(
			.allEdges
		)
		providersCollectionView.pin(
			.fixedHeight(210)
		)
	}
}

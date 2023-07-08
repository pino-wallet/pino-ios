//
//  ProvidersViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import Combine
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

	private var providerDidSelect: ((SwapProviderViewModel) -> Void)!
	private var selectProviderVM = SelectSwapProvidersViewModel()

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	convenience init(providerDidSelect: @escaping (SwapProviderViewModel) -> Void) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)
		self.providerDidSelect = providerDidSelect
		setupView()
		setupStyle()
		setupConstraint()
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupView() {
		providersCollectionView = SwapProvidersCollectionView(providerDidSelect: { provider in

		})
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(providersCollectionView)
		contentStackView.addArrangedSubview(closePageButton)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle() {
		titleLabel.text = selectProviderVM.pageTitle
		descriptionLabel.text = selectProviderVM.pageDescription
		closePageButton.title = selectProviderVM.confirmButtonTitle

		contentView.backgroundColor = .Pino.secondaryBackground
		providersCollectionView.backgroundColor = .Pino.clear
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackView.spacing = 30
		titleStackView.spacing = 12

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

	private func setupBindings() {
		selectProviderVM.$providers.sink { providers in
			if let providers {
				self.updateProviderCollectionView(providers: providers)
			} else {
				// Show loading
			}
		}.store(in: &cancellables)
	}

	private func updateProviderCollectionView(providers: [SwapProviderViewModel]) {
		providersCollectionView.swapProviders = providers
		providersCollectionView.bestProvider = selectProviderVM.getBestProvider(providers)
		providersCollectionView.reloadData()
	}
}

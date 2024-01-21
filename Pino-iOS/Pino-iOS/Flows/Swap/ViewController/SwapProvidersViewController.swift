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
	private let providersContainerView = UIView()
	private let loadingview = UIActivityIndicatorView()
	private var providersCollectionView: SwapProvidersCollectionView!

	private var providerDidSelect: ((SwapProviderViewModel) -> Void)!
	private var selectProviderVM = SelectSwapProvidersViewModel()

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	convenience init(
		providers: Published<[SwapProviderViewModel]>.Publisher,
		bestProvider: SwapProviderViewModel,
		selectedProvider: SwapProviderViewModel?,
		providerDidSelect: @escaping (SwapProviderViewModel) -> Void
	) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)
		self.providerDidSelect = providerDidSelect
		providers.sink { [weak self] newProviders in
			self?.selectProviderVM.providers = newProviders
		}.store(in: &cancellables)
		selectProviderVM.bestProvider = bestProvider
		selectProviderVM.selectedProvider = selectedProvider
		setupView()
		setupStyle()
		setupConstraint()
		setupBindings()
	}

	// MARK: - View Override

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let closePageGesture = UITapGestureRecognizer(target: self, action: #selector(closePage(_:)))
		view.superview?.subviews.first?.addGestureRecognizer(closePageGesture)
	}

	// MARK: - Private Methods

	private func setupView() {
		providersCollectionView = SwapProvidersCollectionView(providerDidSelect: { provider in
			self.providerDidSelect(provider)
			self.dismiss(animated: true)
		})
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(providersContainerView)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		providersContainerView.addSubview(loadingview)
		providersContainerView.addSubview(providersCollectionView)
		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle() {
		titleLabel.text = selectProviderVM.pageTitle
		descriptionLabel.text = selectProviderVM.pageDescription

		contentView.backgroundColor = .Pino.secondaryBackground
		providersCollectionView.backgroundColor = .Pino.clear
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackView.spacing = 30
		titleStackView.spacing = 12

		loadingview.style = .large
		loadingview.color = .Pino.primary
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.bottom(padding: 16),
			.top(padding: 32)
		)
		contentView.pin(
			.allEdges
		)
		providersContainerView.pin(
			.fixedHeight(210)
		)
		providersCollectionView.pin(
			.allEdges()
		)
		loadingview.pin(
			.centerX,
			.centerY
		)
	}

	private func setupBindings() {
		selectProviderVM.$providers.sink { providers in
			if providers.isEmpty {
				self.updateProviderCollectionView(providers: nil)
			} else {
				self.updateProviderCollectionView(providers: providers)
			}
		}.store(in: &cancellables)
	}

	private func updateProviderCollectionView(providers: [SwapProviderViewModel]?) {
		providersCollectionView.swapProviders = providers
		providersCollectionView.bestProvider = selectProviderVM.bestProvider
		providersCollectionView.selectedProvider = selectProviderVM.selectedProvider
		providersCollectionView.reloadData()
	}

	@objc
	private func closePage(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true)
	}
}

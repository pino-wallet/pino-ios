//
//  SwapFeeView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/4/23.
//

import Combine
import UIKit

class SwapFeeView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let contentSpacerView = UIView()
	private let feeInfoStackView = UIStackView()
	private let amountStackView = UIStackView()
	private let saveAmountStackView = UIStackView()
	private let providerStackView = UIStackView()
	private let priceImpactStackView = UIStackView()
	private let feeStackView = UIStackView()
	private let amountLabel = UILabel()
	private let amountSpacerView = UIView()
	private let impactTagStackView = UIStackView()
	private let impactTagView = UIView()
	private let impactTagLabel = UILabel()
	private let collapsButton = UIButton()
	private let saveAmountTitleLabel = UILabel()
	private let saveAmountLabel = UILabel()
	private let providerTitle = UILabel()
	private let providerChangeStackView = UIStackView()
	private let providerImageView = UIImageView()
	private let providerNameLabel = UILabel()
	private let providerChangeIcon = UIImageView()
	private let priceImpactTitleLabel = UILabel()
	private let priceImpactLabel = UILabel()
	private let feeTitleLabel = UILabel()
	private let feeLabel = UILabel()
	private let feeLoadingStackView = UIStackView()
	private let feeLoadingLabel = UILabel()
	private let feeLoadingIndicator = UIActivityIndicatorView()

	private let openFeeInfoIcon = UIImage(named: "chevron_down")
	private let closeFeeInfoIcon = UIImage(named: "chevron_up")

	private var isCollapsed = false

	private let swapFeeVM: SwapFeeViewModel
	private var providerChange: () -> Void

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(swapFeeVM: SwapFeeViewModel, providerChange: @escaping () -> Void) {
		self.swapFeeVM = swapFeeVM
		self.providerChange = providerChange
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
		setupBinding()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(feeLoadingStackView)
		addSubview(amountStackView)
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(contentSpacerView)
		contentStackView.addArrangedSubview(feeInfoStackView)
		feeInfoStackView.addArrangedSubview(saveAmountStackView)
		feeInfoStackView.addArrangedSubview(providerStackView)
		feeInfoStackView.addArrangedSubview(priceImpactStackView)
		feeInfoStackView.addArrangedSubview(feeStackView)
		amountStackView.addArrangedSubview(amountLabel)
		amountStackView.addArrangedSubview(amountSpacerView)
		amountStackView.addArrangedSubview(impactTagStackView)
		impactTagStackView.addArrangedSubview(impactTagView)
		impactTagStackView.addArrangedSubview(collapsButton)
		impactTagView.addSubview(impactTagLabel)
		saveAmountStackView.addArrangedSubview(saveAmountTitleLabel)
		saveAmountStackView.addArrangedSubview(saveAmountLabel)
		providerStackView.addArrangedSubview(providerTitle)
		providerStackView.addArrangedSubview(providerChangeStackView)
		providerChangeStackView.addArrangedSubview(providerImageView)
		providerChangeStackView.addArrangedSubview(providerNameLabel)
		providerChangeStackView.addArrangedSubview(providerChangeIcon)
		priceImpactStackView.addArrangedSubview(priceImpactTitleLabel)
		priceImpactStackView.addArrangedSubview(priceImpactLabel)
		feeStackView.addArrangedSubview(feeTitleLabel)
		feeStackView.addArrangedSubview(feeLabel)
		feeLoadingStackView.addArrangedSubview(feeLoadingIndicator)
		feeLoadingStackView.addArrangedSubview(feeLoadingLabel)

		collapsButton.addAction(UIAction(handler: { _ in
			self.collapsFeeCard()
		}), for: .touchUpInside)

		let providerChangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProvider))
		providerChangeStackView.addGestureRecognizer(providerChangeTapGesture)
	}

	private func setupStyle() {
		saveAmountTitleLabel.text = swapFeeVM.saveAmountTitle
		providerTitle.text = swapFeeVM.providerTitle
		priceImpactTitleLabel.text = swapFeeVM.priceImpactTitle
		feeTitleLabel.text = swapFeeVM.feeTitle
		feeLoadingLabel.text = swapFeeVM.loadingText

		collapsButton.setImage(openFeeInfoIcon, for: .normal)
		providerChangeIcon.image = UIImage(named: "chevron_right")

		amountLabel.font = .PinoStyle.mediumBody
		impactTagLabel.font = .PinoStyle.semiboldFootnote
		saveAmountTitleLabel.font = .PinoStyle.mediumBody
		saveAmountLabel.font = .PinoStyle.mediumBody
		providerTitle.font = .PinoStyle.mediumBody
		providerNameLabel.font = .PinoStyle.mediumBody
		feeTitleLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		priceImpactTitleLabel.font = .PinoStyle.mediumBody
		priceImpactLabel.font = .PinoStyle.mediumBody
		feeLoadingLabel.font = .PinoStyle.mediumBody

		amountLabel.textColor = .Pino.label
		saveAmountTitleLabel.textColor = .Pino.secondaryLabel
		saveAmountLabel.textColor = .Pino.green
		providerTitle.textColor = .Pino.secondaryLabel
		providerNameLabel.textColor = .Pino.label
		feeTitleLabel.textColor = .Pino.secondaryLabel
		feeLabel.textColor = .Pino.label
		priceImpactTitleLabel.textColor = .Pino.secondaryLabel
		priceImpactLabel.textColor = .Pino.orange
		feeLoadingLabel.textColor = .Pino.label

		collapsButton.tintColor = .Pino.label
		providerChangeIcon.tintColor = .Pino.secondaryLabel

		saveAmountLabel.textAlignment = .right

		contentStackView.axis = .vertical
		feeInfoStackView.axis = .vertical

		contentStackView.spacing = 20
		feeInfoStackView.spacing = 20
		impactTagStackView.spacing = 2
		providerChangeStackView.spacing = 3
		feeLoadingStackView.spacing = 12

		providerChangeStackView.alignment = .center
		impactTagStackView.alignment = .center

		impactTagView.layer.cornerRadius = 14
		contentStackView.layer.masksToBounds = true

		feeLoadingIndicator.style = .medium
		feeLoadingIndicator.color = .Pino.primary

		feeInfoStackView.isHidden = true
		impactTagView.alpha = 1

		feeLabel.isSkeletonable = true
	}

	private func setupConstraint() {
		amountStackView.pin(
			.horizontalEdges(padding: 14),
			.top(padding: 15)
		)
		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.top(to: amountStackView, .bottom),
			.bottom(padding: 15)
		)
		impactTagView.pin(
			.fixedHeight(28)
		)
		impactTagLabel.pin(
			.horizontalEdges(padding: 8),
			.centerY
		)
		collapsButton.pin(
			.fixedWidth(24),
			.fixedHeight(24)
		)
		providerImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		providerChangeIcon.pin(
			.fixedWidth(16),
			.fixedHeight(16)
		)
		feeLoadingStackView.pin(
			.allEdges(padding: 16)
		)
		NSLayoutConstraint.activate([
			impactTagView.widthAnchor.constraint(greaterThanOrEqualToConstant: 28),
		])
	}

	private func collapsFeeCard() {
		UIView.animate(withDuration: 0.3) {
			self.feeInfoStackView.isHidden.toggle()
			self.isCollapsed.toggle()
			if self.isCollapsed {
				self.collapsButton.setImage(self.closeFeeInfoIcon, for: .normal)
				self.impactTagView.alpha = 0
			} else {
				self.collapsButton.setImage(self.openFeeInfoIcon, for: .normal)
				self.impactTagView.alpha = 1
			}
		}
	}

	private func setupBinding() {
		swapFeeVM.$feeTag.sink { tag in
			self.updateTagView(tag)
		}.store(in: &cancellables)

		swapFeeVM.$swapProviderVM.sink { swapProviderVM in
			self.updateProviderView(swapProviderVM)
		}.store(in: &cancellables)

		swapFeeVM.$saveAmount.sink { saveAmount in
			self.updateSaveAmount(saveAmount)
		}.store(in: &cancellables)

		swapFeeVM.$priceImpact.sink { priceImpact in
			self.updatePriceImpact(priceImpact)
		}.store(in: &cancellables)

		swapFeeVM.$fee.sink { fee in
			self.updateFee(fee)
		}.store(in: &cancellables)
	}

	private func updateTagView(_ tag: SwapFeeViewModel.FeeTag) {
		switch tag {
		case .highImpact:
			impactTagView.isHidden = false
			impactTagView.backgroundColor = .Pino.lightOrange
			impactTagLabel.text = swapFeeVM.highImpactTagTitle
			impactTagLabel.textColor = .Pino.orange
		case let .save(amount):
			impactTagView.isHidden = false
			impactTagView.backgroundColor = .Pino.green1
			impactTagLabel.text = amount
			impactTagLabel.textColor = .Pino.label
		case .none:
			impactTagView.isHidden = true
		}
	}

	private func updateProviderView(_ swapProviderVM: SwapProviderViewModel?) {
		if let swapProviderVM {
			providerStackView.isHidden = false
			providerImageView.image = UIImage(named: swapProviderVM.provider.image)
			providerNameLabel.text = swapProviderVM.provider.name
		} else {
			providerStackView.isHidden = true
		}
	}

	private func updateSaveAmount(_ saveAmount: String?) {
		if let saveAmount {
			saveAmountStackView.isHidden = false
			saveAmountLabel.text = swapFeeVM.formattedSaveAmount(saveAmount)
		} else {
			saveAmountStackView.isHidden = true
		}
	}

	private func updatePriceImpact(_ priceImpact: String?) {
		if let priceImpact {
			priceImpactStackView.isHidden = false
			priceImpactLabel.text = priceImpact.percentFormatting
		} else {
			priceImpactStackView.isHidden = true
		}
	}

	private func updateFee(_ fee: String?) {
		if let fee {
			feeLabel.text = fee.ethFormatting
			hideLoading()
		} else {
			showLoading()
		}
	}

	private func showLoading() {
		if isCollapsed {
			feeInfoStackView.isHidden = true
		}
		amountStackView.isHidden = true
		contentStackView.isHidden = true
		feeLoadingStackView.isHidden = false
		feeLoadingIndicator.startAnimating()
	}

	private func hideLoading() {
		if isCollapsed {
			feeInfoStackView.isHidden = false
		}
		amountStackView.isHidden = false
		contentStackView.isHidden = false
		feeLoadingStackView.isHidden = true
		feeLoadingIndicator.stopAnimating()
	}

	@objc
	private func changeProvider() {
		providerChange()
	}

	// MARK: - Public Methods

	public func updateCalculatedAmount(_ amount: String) {
		amountLabel.text = amount
	}
}

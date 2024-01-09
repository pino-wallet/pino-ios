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
	private let amountWarningImage = UIImageView()
	private let amountLabel = UILabel()
	private let amountSpacerView = UIView()
	private let providerTagView = UIImageView()
	private let impactTagStackView = UIStackView()
	private let impactTagView = UIView()
	private let impactTagLabel = UILabel()
	private let collapsButton = UIImageView()
	private let saveAmountTitleLabel = UILabel()
	private let saveAmountLabel = UILabel()
	private let providerTitleStackView = UIStackView()
	private let providerTitle = UILabel()
	private let bestRateTagView = UIView()
	private let bestRateTagTitle = UILabel()
	private let providerSpacerView = UIView()
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
	private let feeLoadingIndicator = PinoLoading(size: 22)

	private let openFeeInfoIcon = UIImage(named: "chevron_down")
	private let closeFeeInfoIcon = UIImage(named: "chevron_up")

	private var isCollapsed = true
	private var showFeeInDollar = true

	private let swapFeeVM: SwapFeeViewModel
	private var providerChange: () -> Void

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var feeCardOpened: (() -> Void)!

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
		amountStackView.addArrangedSubview(amountWarningImage)
		amountStackView.addArrangedSubview(amountLabel)
		amountStackView.addArrangedSubview(amountSpacerView)
		amountStackView.addArrangedSubview(providerTagView)
		amountStackView.addArrangedSubview(impactTagStackView)
		impactTagStackView.addArrangedSubview(impactTagView)
		impactTagStackView.addArrangedSubview(collapsButton)
		impactTagView.addSubview(impactTagLabel)
		saveAmountStackView.addArrangedSubview(saveAmountTitleLabel)
		saveAmountStackView.addArrangedSubview(saveAmountLabel)
		providerStackView.addArrangedSubview(providerTitleStackView)
		providerStackView.addArrangedSubview(providerSpacerView)
		providerStackView.addArrangedSubview(providerChangeStackView)
		providerTitleStackView.addArrangedSubview(providerTitle)
		providerTitleStackView.addArrangedSubview(bestRateTagView)
		bestRateTagView.addSubview(bestRateTagTitle)
		providerChangeStackView.addArrangedSubview(providerImageView)
		providerChangeStackView.addArrangedSubview(providerNameLabel)
		providerChangeStackView.addArrangedSubview(providerChangeIcon)
		priceImpactStackView.addArrangedSubview(priceImpactTitleLabel)
		priceImpactStackView.addArrangedSubview(priceImpactLabel)
		feeStackView.addArrangedSubview(feeTitleLabel)
		feeStackView.addArrangedSubview(feeLabel)
		feeLoadingStackView.addArrangedSubview(feeLoadingIndicator)
		feeLoadingStackView.addArrangedSubview(feeLoadingLabel)

		amountStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collapsFeeCard)))

		let providerChangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProvider))
		providerChangeStackView.addGestureRecognizer(providerChangeTapGesture)

		let feeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFeeValue))
		feeLabel.addGestureRecognizer(feeLabelTapGesture)
		feeLabel.isUserInteractionEnabled = true
	}

	private func setupStyle() {
		saveAmountTitleLabel.text = swapFeeVM.saveAmountTitle
		providerTitle.text = swapFeeVM.providerTitle
		priceImpactTitleLabel.text = swapFeeVM.priceImpactTitle
		feeTitleLabel.text = swapFeeVM.feeTitle
		feeLoadingLabel.text = swapFeeVM.loadingText
		bestRateTagTitle.text = "Best rate"

		collapsButton.image = openFeeInfoIcon
		providerChangeIcon.image = UIImage(named: "chevron_right")
		amountWarningImage.image = UIImage(named: "swap_warning")

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
		bestRateTagTitle.font = .PinoStyle.SemiboldCaption2

		amountLabel.textColor = .Pino.label
		saveAmountTitleLabel.textColor = .Pino.secondaryLabel
		saveAmountLabel.textColor = .Pino.green
		providerTitle.textColor = .Pino.secondaryLabel
		providerNameLabel.textColor = .Pino.label
		feeTitleLabel.textColor = .Pino.secondaryLabel
		feeLabel.textColor = .Pino.label
		priceImpactTitleLabel.textColor = .Pino.secondaryLabel
		feeLoadingLabel.textColor = .Pino.label
		bestRateTagTitle.textColor = .Pino.white

		collapsButton.tintColor = .Pino.label
		providerChangeIcon.tintColor = .Pino.secondaryLabel

		bestRateTagView.backgroundColor = .orange

		saveAmountLabel.textAlignment = .right

		contentStackView.axis = .vertical
		feeInfoStackView.axis = .vertical

		contentStackView.spacing = 16
		feeInfoStackView.spacing = 20
		impactTagStackView.spacing = 2
		providerChangeStackView.spacing = 3
		feeLoadingStackView.spacing = 10
		feeLoadingStackView.alignment = .center
		providerTitleStackView.spacing = 5

		providerChangeStackView.alignment = .center
		impactTagStackView.alignment = .center
		amountStackView.alignment = .center

		impactTagView.layer.cornerRadius = 14
		contentStackView.layer.masksToBounds = true
		bestRateTagView.layer.cornerRadius = 12
		bestRateTagView.layer.masksToBounds = true

		feeInfoStackView.isHidden = true
		feeStackView.isHidden = true
		impactTagView.alpha = 1
	}

	private func setupConstraint() {
		amountStackView.pin(
			.leading(padding: 14),
			.trailing(padding: 8),
			.top(padding: 10),
			.fixedHeight(28)
		)
		contentStackView.pin(
			.horizontalEdges(padding: 14),
			.top(to: amountStackView, .bottom),
			.bottom(padding: 10)
		)
		feeInfoStackView.pin(
			.bottom(padding: 5)
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
			.allEdges(padding: 10)
		)
		bestRateTagView.pin(
			.fixedWidth(60),
			.fixedHeight(24)
		)
		bestRateTagTitle.pin(
			.centerX,
			.centerY
		)
		amountWarningImage.pin(
			.fixedWidth(30),
			.fixedHeight(30)
		)
		providerTagView.pin(
			.fixedHeight(24),
			.fixedWidth(24)
		)
		NSLayoutConstraint.activate([
			impactTagView.widthAnchor.constraint(greaterThanOrEqualToConstant: 28),
		])
	}

	@objc
	private func collapsFeeCard() {
		UIView.animate(withDuration: 0.3) {
			if self.isCollapsed {
				self.showFeeInfo()
				self.feeCardOpened()
			} else {
				self.hideFeeInfo()
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

		swapFeeVM.$calculatedAmount.sink { amount in
			self.updateCalculatedAmount(amount)
		}.store(in: &cancellables)

		swapFeeVM.$priceImpact.sink { priceImpact in
			self.updatePriceImpact(priceImpact)
		}.store(in: &cancellables)

		swapFeeVM.$isBestRate.sink { isBestRate in
			self.bestRateTagView.isHiddenInStackView = !isBestRate
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
			providerTagView.isHiddenInStackView = false
			providerImageView.image = UIImage(named: swapProviderVM.provider.image)
			providerTagView.image = UIImage(named: swapProviderVM.provider.image)
			providerNameLabel.text = swapProviderVM.provider.name
		} else {
			providerStackView.isHidden = true
			providerTagView.isHiddenInStackView = true
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
			switch swapFeeVM.priceImpactStatus {
			case .low:
				amountWarningImage.isHiddenInStackView = true
				amountLabel.textColor = .Pino.label
				priceImpactLabel.textColor = .Pino.green
			case .high:
				amountWarningImage.isHiddenInStackView = true
				amountLabel.textColor = .Pino.label
				priceImpactLabel.textColor = .Pino.orange
			case .veryHigh:
				amountWarningImage.isHiddenInStackView = false
				amountLabel.textColor = .Pino.red
				priceImpactLabel.textColor = .Pino.red
			case .normal:
				amountWarningImage.isHiddenInStackView = true
				amountLabel.textColor = .Pino.label
				priceImpactLabel.textColor = .Pino.label
			}
		} else {
			priceImpactStackView.isHidden = true
		}
	}

	private func updateCalculatedAmount(_ amount: String?) {
		amountLabel.text = amount
	}

	@objc
	private func changeProvider() {
		providerChange()
	}

	@objc
	private func toggleFeeValue() {
		showFeeInDollar.toggle()
	}

	private func addBestRateGradient() {
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [
			CGColor(red: 0.73, green: 0.38, blue: 1, alpha: 1),
			CGColor(red: 1, green: 0.43, blue: 0.43, alpha: 1),
			CGColor(red: 0.74, green: 0.66, blue: 0, alpha: 1),
			CGColor(red: 0.32, green: 0.8, blue: 0.09, alpha: 1),
		]
		gradientLayer.locations = [0.0, 0.33, 0.67, 1.0]
		gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
		gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
		gradientLayer.frame = bestRateTagView.bounds
		bestRateTagView.layer.insertSublayer(gradientLayer, at: 0)
	}

	// MARK: - Public Methods

	public func hideFeeInfo() {
		isCollapsed = true
		feeInfoStackView.isHiddenInStackView = true
		collapsButton.image = openFeeInfoIcon
		providerTagView.alpha = 1
		impactTagView.alpha = 0
	}

	public func showFeeInfo() {
		isCollapsed = false
		collapsButton.image = closeFeeInfoIcon
		providerTagView.alpha = 0
		impactTagView.alpha = 1
		if feeLoadingIndicator.isHidden {
			feeInfoStackView.isHiddenInStackView = false
		}
	}

	public func showLoading() {
		if !isCollapsed {
			feeInfoStackView.isHiddenInStackView = true
		}
		amountStackView.isHiddenInStackView = true
		contentStackView.isHiddenInStackView = true
		feeLoadingStackView.isHiddenInStackView = false
		feeLoadingIndicator.isHiddenInStackView = false
	}

	public func hideLoading() {
		if !isCollapsed {
			feeInfoStackView.isHiddenInStackView = false
		}
		amountStackView.isHiddenInStackView = false
		contentStackView.isHiddenInStackView = false
		feeLoadingStackView.isHiddenInStackView = true
		feeLoadingIndicator.isHiddenInStackView = true
	}

	override func layoutSubviews() {
		addBestRateGradient()
	}
}

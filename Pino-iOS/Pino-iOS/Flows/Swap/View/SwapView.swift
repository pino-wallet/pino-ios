//
//  SwapView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Combine
import Foundation
import UIKit

class SwapView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let protocolCardView = PinoContainerCard()
	private let swapCardView = PinoContainerCard()
	private let feeCardView = PinoContainerCard()
	private let protocolStackView = UIStackView()
	private let protocolTitleStackView = UIStackView()
	private let protocolImage = UIImageView()
	private let protocolName = UILabel()
	private let protocolChangeIcon = UIImageView()
	private let swapStackView = UIStackView()
	private let switchTokenView = UIView()
	private let switchTokenLineView = UIView()
	private let switchTokenButton = UIButton()
	private let continueButton = PinoButton(style: .deactive)
	private var fromTokenSectionView: SwapTokenSectionView!
	private var toTokenSectionView: SwapTokenSectionView!
	private let swapFeeView: SwapFeeView
	private let hapticManager = HapticManager()

	private var fromTokenChange: () -> Void
	private var toTokeChange: () -> Void
	private var nextButtonTapped: () -> Void
	private var swapProtocolChange: () -> Void
	private var swapVM: SwapViewModel

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Internal Properties

	internal var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	internal var nextButtonBottomConstraint: NSLayoutConstraint!
	internal let nextButtonBottomConstant = CGFloat(12)

	// MARK: - public Properties

	@Published
	public var keyboardIsOpen = false

	// MARK: - Initializers

	init(
		swapVM: SwapViewModel,
		fromTokenChange: @escaping (() -> Void),
		toTokeChange: @escaping (() -> Void),
		swapProtocolChange: @escaping (() -> Void),
		providerChange: @escaping (() -> Void),
		nextButtonTapped: @escaping (() -> Void)
	) {
		self.fromTokenChange = fromTokenChange
		self.toTokeChange = toTokeChange
		self.swapProtocolChange = swapProtocolChange
		self.nextButtonTapped = nextButtonTapped
		self.swapVM = swapVM
		self.swapFeeView = SwapFeeView(swapFeeVM: swapVM.swapFeeVM, providerChange: providerChange)
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBinding()
		setupNotifications()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		fromTokenSectionView = SwapTokenSectionView(
			swapVM: swapVM.fromToken,
			changeSelectedToken: fromTokenChange
		)

		toTokenSectionView = SwapTokenSectionView(
			swapVM: swapVM.toToken,
			hasMaxAmount: false,
			changeSelectedToken: toTokeChange
		)

		addSubview(contentStackView)
		addSubview(continueButton)
		contentStackView.addArrangedSubview(swapCardView)
		contentStackView.addArrangedSubview(feeCardView)
		protocolCardView.addSubview(protocolStackView)
		protocolStackView.addArrangedSubview(protocolTitleStackView)
		protocolStackView.addArrangedSubview(protocolChangeIcon)
		protocolTitleStackView.addArrangedSubview(protocolImage)
		protocolTitleStackView.addArrangedSubview(protocolName)
		swapCardView.addSubview(swapStackView)
		swapStackView.addArrangedSubview(fromTokenSectionView)
		swapStackView.addArrangedSubview(switchTokenView)
		swapStackView.addArrangedSubview(toTokenSectionView)
		switchTokenView.addSubview(switchTokenLineView)
		switchTokenView.addSubview(switchTokenButton)
		feeCardView.addSubview(swapFeeView)

		continueButton.addAction(UIAction(handler: { _ in
			self.hapticManager.run(type: .lightImpact)
			self.continueButton.style = .loading
			self.nextButtonTapped()
		}), for: .touchUpInside)

		switchTokenButton.addAction(UIAction(handler: { _ in
			self.hapticManager.run(type: .lightImpact)
			self.switchTokens()
		}), for: .touchUpInside)

		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dissmisskeyBoard))
		swipeGestureRecognizer.direction = .down
		addGestureRecognizer(swipeGestureRecognizer)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

		let protocolChangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeSwapProtocol))
		protocolCardView.addGestureRecognizer(protocolChangeTapGesture)

		fromTokenSectionView.balanceStatusDidChange = { balanceStatus in
			self.updateSwapStatus(balanceStatus)
		}
		fromTokenSectionView.editingBegin = {
			self.swapVM.fromToken.isEditing = true
			self.swapVM.toToken.isEditing = false
		}
		toTokenSectionView.editingBegin = {
			self.swapVM.toToken.isEditing = true
			self.swapVM.fromToken.isEditing = false
		}
	}

	private func setupStyle() {
		continueButton.title = swapVM.continueButtonTitle

		protocolChangeIcon.image = UIImage(named: "chevron_down")
		switchTokenButton.setImage(UIImage(named: swapVM.switchIcon), for: .normal)

		protocolName.font = .PinoStyle.mediumBody

		protocolName.textColor = .Pino.label
		switchTokenButton.tintColor = .Pino.primary
		protocolChangeIcon.tintColor = .Pino.label

		backgroundColor = .Pino.background
		switchTokenLineView.backgroundColor = .Pino.background
		switchTokenButton.backgroundColor = .Pino.background

		switchTokenButton.layer.cornerRadius = 12

		contentStackView.axis = .vertical
		swapStackView.axis = .vertical

		contentStackView.spacing = 12
		protocolTitleStackView.spacing = 8
		swapStackView.spacing = 10

		protocolStackView.alignment = .center

		feeCardView.alpha = 0

		swapFeeView.feeCardOpened = {
			self.dissmisskeyBoard()
		}

		// Hide protocol card in small devices
		if DeviceHelper.shared.size == .small {
			hideProtocolView()
		}
	}

	private func setupContstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 18)
		)
		protocolStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 8)
		)
		protocolImage.pin(
			.fixedHeight(40),
			.fixedWidth(40)
		)
		protocolChangeIcon.pin(
			.fixedWidth(28),
			.fixedHeight(28)
		)
		swapStackView.pin(
			.top(padding: 24),
			.bottom(padding: 28),
			.horizontalEdges
		)
		switchTokenLineView.pin(
			.horizontalEdges,
			.centerY,
			.fixedHeight(1)
		)
		switchTokenButton.pin(
			.fixedWidth(40),
			.fixedHeight(40),
			.verticalEdges,
			.centerX
		)
		swapFeeView.pin(
			.allEdges
		)

		continueButton.pin(
			.horizontalEdges(padding: 16)
		)
		nextButtonBottomConstraint = NSLayoutConstraint(
			item: continueButton,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -nextButtonBottomConstant
		)
		addConstraint(nextButtonBottomConstraint)
	}

	private func setupBinding() {
		swapVM.$selectedProtocol.sink { swapProtocol in
			self.updateSwapProtocol(swapProtocol)
		}.store(in: &cancellables)

		swapVM.$swapState.sink { [self] swapState in
			switch swapState {
			case .initial:
				deactivateSwapButton()
				hideFeeCard()
				clearTextFields()
				toTokenSectionView.showSelectAssetButton()
				toTokenSectionView.hideDollarAmount()
			case .clear:
				deactivateSwapButton()
				hideFeeCard()
				toTokenSectionView.unlockTextField()
				toTokenSectionView.hideSelectAssetButton()
				clearTextFields()
				toTokenSectionView.showDollarAmount()
			case .hasAmount:
				activateSwapButton()
				showFeeCard()
				swapFeeView.hideLoading()
				toTokenSectionView.hideSelectAssetButton()
				toTokenSectionView.showDollarAmount()
			case .loading:
				deactivateSwapButton()
				showFeeCard()
				swapFeeView.showLoading()
				toTokenSectionView.hideSelectAssetButton()
				swapFeeView.hideNoQuoteError()
				toTokenSectionView.showDollarAmount()
			case .noQuote:
				deactivateSwapButton()
				showFeeCard()
				swapFeeView.hideLoading()
				toTokenSectionView.hideSelectAssetButton()
				swapFeeView.showNoQuoteError()
			case .noToToken:
				deactivateSwapButton()
				hideFeeCard()
				toTokenSectionView.showSelectAssetButton()
				toTokenSectionView.hideDollarAmount()
			}
		}.store(in: &cancellables)
	}

	private func updateSwapProtocol(_ swapProtocol: SwapProtocolModel) {
		protocolName.text = swapProtocol.name
		protocolImage.image = UIImage(named: swapProtocol.image)
	}

	private func updateSwapStatus(_ status: AmountStatus) {
		switch status {
		case .isZero:
			continueButton.setTitle(swapVM.continueButtonTitle, for: .normal)
		case .isEnough:
			continueButton.setTitle(swapVM.continueButtonTitle, for: .normal)
		case .isNotEnough:
			continueButton.setTitle(swapVM.insufficientAmountButtonTitle, for: .normal)
		}
	}

	@objc
	private func dissmisskeyBoard() {
		fromTokenSectionView.dissmisskeyBoard()
		toTokenSectionView.dissmisskeyBoard()
	}

	private func switchTokens() {
		switch swapVM.swapState {
		case .initial, .noToToken, .loading:
			break
		case .clear, .hasAmount, .noQuote:
			switchTextFieldsFocus()
			swapVM.switchTokens()
		}
	}

	private func switchTextFieldsFocus() {
		if swapVM.fromToken.isEditing {
			toTokenSectionView.openKeyboard()
		} else if swapVM.toToken.isEditing {
			fromTokenSectionView.openKeyboard()
		} else {
			fromTokenSectionView.dissmisskeyBoard()
			toTokenSectionView.dissmisskeyBoard()
		}
	}

	@objc
	private func changeSwapProtocol() {
		swapProtocolChange()
	}

	private func clearTextFields() {
		if let tokenAmount = swapVM.fromToken.tokenAmount, tokenAmount.isZero {
			// Don't delete zero amount from text field
			return
		} else {
			swapVM.fromToken.calculateDollarAmount(nil)
			fromTokenSectionView.swapAmountDidCalculate()
		}
		if let tokenAmount = swapVM.toToken.tokenAmount, tokenAmount.isZero {
			// Don't delete zero amount from text field
			return
		} else {
			swapVM.toToken.calculateDollarAmount(nil)
			toTokenSectionView.swapAmountDidCalculate()
		}
	}

	private func showFeeCard() {
		UIView.animate(withDuration: 0.3) {
			self.feeCardView.alpha = 1
		}
	}

	private func hideFeeCard() {
		UIView.animate(withDuration: 0.3) {
			self.feeCardView.alpha = 0
		}
	}

	private func activateSwapButton() {
		if fromTokenSectionView.balanceStatus == .isEnough {
			continueButton.style = .active
		} else {
			continueButton.style = .deactive
		}
		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Environment.current != .mainNet {
			continueButton.style = .active
		}
	}

	private func deactivateSwapButton() {
		continueButton.style = .deactive
	}

	// MARK: - Public Methods

	public func stopLoading() {
		continueButton.style = .active
	}

	public func showProtocolView() {
		protocolCardView.alpha = 1
		protocolCardView.isHidden = false
	}

	public func hideProtocolView() {
		protocolCardView.alpha = 0
		protocolCardView.isHidden = true
	}

	public func openFeeCard() {
		swapFeeView.showFeeInfo()
	}

	public func closeFeeCard() {
		swapFeeView.hideFeeInfo()
	}
}

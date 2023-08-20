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
	private let swapCardView = PinoContainerCard()
	private let feeCardView = PinoContainerCard()
	private let swapStackView = UIStackView()
	private let switchTokenView = UIView()
	private let switchTokenLineView = UIView()
	private let switchTokenButton = UIButton()
	private let continueButton = PinoButton(style: .deactive)
	private var fromTokenSectionView: SwapTokenSectionView!
	private var toTokenSectionView: SwapTokenSectionView!
	private let swapFeeView: SwapFeeView

	private var fromTokenChange: () -> Void
	private var toTokeChange: () -> Void
	private var nextButtonTapped: () -> Void
	private var swapProtocolChange: () -> Void
	private var swapVM: SwapViewModel
	private var selectDexProtocolView: SelectDexProtocolView!

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

		selectDexProtocolView = SelectDexProtocolView(
			title: swapVM.selectedProtocol.name,
			image: swapVM.selectedProtocol.image,
			onDexProtocolTapClosure: {
				self.swapProtocolChange()
			}
		)

		addSubview(contentStackView)
		addSubview(continueButton)
		contentStackView.addArrangedSubview(selectDexProtocolView)
		contentStackView.addArrangedSubview(swapCardView)
		contentStackView.addArrangedSubview(feeCardView)
		swapCardView.addSubview(swapStackView)
		swapStackView.addArrangedSubview(fromTokenSectionView)
		swapStackView.addArrangedSubview(switchTokenView)
		swapStackView.addArrangedSubview(toTokenSectionView)
		switchTokenView.addSubview(switchTokenLineView)
		switchTokenView.addSubview(switchTokenButton)
		feeCardView.addSubview(swapFeeView)

		continueButton.addAction(UIAction(handler: { _ in
			self.nextButtonTapped()
		}), for: .touchUpInside)

		switchTokenButton.addAction(UIAction(handler: { _ in
			self.switchTokens()
		}), for: .touchUpInside)

		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dissmisskeyBoard))
		swipeGestureRecognizer.direction = .down
		addGestureRecognizer(swipeGestureRecognizer)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

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

		switchTokenButton.setImage(UIImage(named: swapVM.switchIcon), for: .normal)

		switchTokenButton.setTitleColor(.Pino.primary, for: .normal)

		backgroundColor = .Pino.background
		switchTokenLineView.backgroundColor = .Pino.background
		switchTokenButton.backgroundColor = .Pino.background

		switchTokenButton.layer.cornerRadius = 12

		contentStackView.axis = .vertical
		swapStackView.axis = .vertical

		contentStackView.spacing = 12
		swapStackView.spacing = 10

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

		swapVM.swapFeeVM.$calculatedAmount.sink { amount in
			UIView.animate(withDuration: 0.3) {
				if let amount {
					self.swapFeeView.updateCalculatedAmount(amount)
					self.feeCardView.alpha = 1
				} else {
					self.feeCardView.alpha = 0
				}
			}
		}.store(in: &cancellables)
	}

	private func updateSwapProtocol(_ swapProtocol: dexProtocolModel) {
		selectDexProtocolView.titleText = swapProtocol.name
		selectDexProtocolView.imageName = swapProtocol.image
	}

	private func updateSwapStatus(_ status: AmountStatus) {
		switch status {
		case .isZero:
			continueButton.setTitle(swapVM.continueButtonTitle, for: .normal)
			continueButton.style = .deactive
		case .isEnough:
			continueButton.setTitle(swapVM.continueButtonTitle, for: .normal)
			continueButton.style = .active
		case .isNotEnough:
			continueButton.setTitle(swapVM.insufficientAmountButtonTitle, for: .normal)
			continueButton.style = .deactive
		}
	}

	@objc
	private func dissmisskeyBoard() {
		fromTokenSectionView.dissmisskeyBoard()
		toTokenSectionView.dissmisskeyBoard()
	}

	private func switchTokens() {
		if !fromTokenSectionView.isCalculating, !toTokenSectionView.isCalculating {
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
	private func changeSwapProtocol() {}

	// MARK: - Public Methods

	public func showProtocolView() {
		selectDexProtocolView.alpha = 1
		selectDexProtocolView.isHidden = false
	}

	public func hideProtocolView() {
		selectDexProtocolView.alpha = 0
		selectDexProtocolView.isHidden = true
	}

	public func openFeeCard() {
		swapFeeView.showFeeInfo()
	}

	public func closeFeeCard() {
		swapFeeView.hideFeeInfo()
	}
}

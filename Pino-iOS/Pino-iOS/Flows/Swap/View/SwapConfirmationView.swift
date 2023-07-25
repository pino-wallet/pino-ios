//
//  SwapConfirmationView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import Combine
import UIKit

class SwapConfirmationView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let cardsStackView = UIStackView()
	private let tokenCardView = PinoContainerCard()
	private let swapInfoCardView = PinoContainerCard()
	private let tokenStackView = UIStackView()
	private let fromTokenView: SwapConfirmationTokenView
	private let toTokenView: SwapConfirmationTokenView
	private let arrowImageView = UIImageView()
	private let swapArrowStackView = UIStackView()
	private let swapArrowSpacerView = UIView()
	private let swapConfirmationInfoView: SwapConfirmationInfoView
	private let continueButton = PinoButton(style: .active)

	private let swapConfirmationVM: SwapConfirmationViewModel
	private let confirmButtonTapped: () -> Void
	private let presentFeeInfo: (InfoActionSheet) -> Void
	private let retryFeeCalculation: () -> Void
	private var cancellables = Set<AnyCancellable>()
	private var showFeeInDollar = true

	// MARK: - Initializers

	init(
		swapConfirmationVM: SwapConfirmationViewModel,
		confirmButtonTapped: @escaping () -> Void,
		presentFeeInfo: @escaping (InfoActionSheet) -> Void,
		retryFeeCalculation: @escaping () -> Void
	) {
		self.swapConfirmationVM = swapConfirmationVM
		self.confirmButtonTapped = confirmButtonTapped
		self.presentFeeInfo = presentFeeInfo
		self.retryFeeCalculation = retryFeeCalculation
		self.swapConfirmationInfoView = SwapConfirmationInfoView(
			swapConfirmationVM: swapConfirmationVM,
			presentFeeInfo: presentFeeInfo,
			retryFeeCalculation: retryFeeCalculation
		)
		self.fromTokenView = SwapConfirmationTokenView(swapTokenVM: swapConfirmationVM.fromToken)
		self.toTokenView = SwapConfirmationTokenView(swapTokenVM: swapConfirmationVM.toToken)
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackview)
		addSubview(continueButton)
		contentStackview.addArrangedSubview(cardsStackView)
		cardsStackView.addArrangedSubview(tokenCardView)
		cardsStackView.addArrangedSubview(swapInfoCardView)
		tokenCardView.addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(fromTokenView)
		tokenStackView.addArrangedSubview(swapArrowStackView)
		tokenStackView.addArrangedSubview(toTokenView)
		swapArrowStackView.addArrangedSubview(arrowImageView)
		swapArrowStackView.addArrangedSubview(swapArrowSpacerView)
		swapInfoCardView.addSubview(swapConfirmationInfoView)

		continueButton.addAction(UIAction(handler: { _ in
			self.confirmButtonTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		continueButton.title = swapConfirmationVM.confirmButtonTitle
		arrowImageView.image = UIImage(named: "arrow_down")

		backgroundColor = .Pino.background

		cardsStackView.axis = .vertical
		tokenStackView.axis = .vertical
		contentStackview.axis = .vertical

		contentStackview.spacing = 24
		cardsStackView.spacing = 18

		showSkeletonView()
		continueButton.style = .deactive
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 25)
		)
		tokenStackView.pin(
			.allEdges
		)
		continueButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		arrowImageView.pin(
			.fixedWidth(24),
			.fixedHeight(24),
			.leading(padding: 20)
		)
		swapConfirmationInfoView.pin(
			.allEdges
		)
	}

	private func setupBindings() {
		Publishers.Zip(swapConfirmationVM.$formattedFeeInDollar, swapConfirmationVM.$formattedFeeInETH)
			.sink { [weak self] feeInDollar, feeInETH in
				guard let self, let feeInETH, let feeInDollar else { return }
				self.swapConfirmationInfoView.hideSkeletonView()
				self.swapConfirmationInfoView.updateFeeLabel(feeInETH: feeInETH, feeInDollar: feeInDollar)
				self.checkBalanceEnough()
			}.store(in: &cancellables)
	}

	private func checkBalanceEnough() {
		if swapConfirmationVM.checkEnoughBalance() {
			continueButton.style = .active
			continueButton.setTitle(swapConfirmationVM.confirmButtonTitle, for: .normal)
		} else {
			continueButton.style = .deactive
			continueButton.setTitle(swapConfirmationVM.insufficientTitle, for: .normal)
		}
	}
}
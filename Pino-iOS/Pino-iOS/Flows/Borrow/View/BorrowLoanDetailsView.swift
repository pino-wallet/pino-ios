//
//  BorrowLoanDetailsview.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Combine
import Kingfisher
import UIKit

class BorrowLoanDetailsView: UIView {
	// MARK: - Closures

	public var pushToBorrowIncreaseAmountPageClosure: () -> Void
	public var pushToRepayAmountPageClosure: () -> Void

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let headerContainerView = PinoContainerCard()
	private let headerStackView = UIStackView()
	private let headerTitleImage = UIImageView()
	private let headerTitleLabel = PinoLabel(style: .title, text: "")
	private let headerAmountInDollarsLabel = PinoLabel(style: .description, text: "")
	private let contentContainerView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let borderView = UIView()
	private let buttonsStackView = UIStackView()
	private let increaseButton = PinoButton(style: .active)
	private let repayButton = PinoButton(style: .secondary)
	private var apyStackView: LoanDetailsInfoStackView!
	private var borrowedAmountStackView: LoanDetailsInfoStackView!
	private var accuredFeeStackView: LoanDetailsInfoStackView!
	private var totalDebtStackView: LoanDetailsInfoStackView!
	private var cancellables = Set<AnyCancellable>()

	private var borrowLoanDetailsVM: BorrowLoanDetailsViewModel

	// MARK: - Initializers

	init(
		borrowLoanDetailsVM: BorrowLoanDetailsViewModel,
		pushToBorrowIncreaseAmountPageClosure: @escaping () -> Void,
		pushToRepayAmountPageClosure: @escaping () -> Void
	) {
		self.borrowLoanDetailsVM = borrowLoanDetailsVM
		self.pushToBorrowIncreaseAmountPageClosure = pushToBorrowIncreaseAmountPageClosure
		self.pushToRepayAmountPageClosure = pushToRepayAmountPageClosure

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
		setupSkeletonView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		increaseButton.addTarget(self, action: #selector(onIncreaseBorrowButtonTap), for: .touchUpInside)

		repayButton.addTarget(self, action: #selector(onRepayButtonTap), for: .touchUpInside)

		apyStackView = LoanDetailsInfoStackView(
			titleText: borrowLoanDetailsVM.apyTitle,
			infoText: borrowLoanDetailsVM.apy
		)
		borrowedAmountStackView = LoanDetailsInfoStackView(
			titleText: borrowLoanDetailsVM.borrowedAmountTitle,
			infoText: borrowLoanDetailsVM.borrowedAmount
		)
		accuredFeeStackView = LoanDetailsInfoStackView(
			titleText: borrowLoanDetailsVM.accuredFeeTitle,
			infoText: borrowLoanDetailsVM.accuredFee
		)
		totalDebtStackView = LoanDetailsInfoStackView(
			titleText: borrowLoanDetailsVM.totalDebtTitle,
			infoText: borrowLoanDetailsVM.totalDebt
		)

		contentContainerView.addSubview(contentStackView)

		contentStackView.addArrangedSubview(apyStackView)
		contentStackView.addArrangedSubview(borrowedAmountStackView)
		contentStackView.addArrangedSubview(accuredFeeStackView)
		contentStackView.addArrangedSubview(borderView)
		contentStackView.addArrangedSubview(totalDebtStackView)

		headerStackView.addArrangedSubview(headerTitleImage)
		headerStackView.addArrangedSubview(headerTitleLabel)
		headerStackView.addArrangedSubview(headerAmountInDollarsLabel)

		headerContainerView.addSubview(headerStackView)

		mainStackView.addArrangedSubview(headerContainerView)
		mainStackView.addArrangedSubview(contentContainerView)

		buttonsStackView.addArrangedSubview(increaseButton)
		buttonsStackView.addArrangedSubview(repayButton)

		addSubview(mainStackView)
		addSubview(buttonsStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		totalDebtStackView.titleLabel.textColor = .Pino.label

		totalDebtStackView.infoLabel.font = .PinoStyle.semiboldBody

		mainStackView.axis = .vertical
		mainStackView.spacing = 16

		headerStackView.axis = .vertical
		headerStackView.spacing = 16
		headerStackView.alignment = .center
		headerStackView.setCustomSpacing(4, after: headerTitleLabel)

		headerTitleImage.kf.indicatorType = .activity
		headerTitleImage.kf.setImage(with: borrowLoanDetailsVM.tokenIcon)

		headerTitleLabel.font = .PinoStyle.semiboldTitle2
		headerTitleLabel.text = borrowLoanDetailsVM.tokenBorrowAmountAndSymbol
		headerTitleLabel.numberOfLines = 0

		contentStackView.axis = .vertical
		contentStackView.spacing = 16

		increaseButton.title = borrowLoanDetailsVM.increaseLoanTitle

		repayButton.title = borrowLoanDetailsVM.repayTitle

		borderView.backgroundColor = .Pino.gray5

		buttonsStackView.axis = .vertical
		buttonsStackView.spacing = 24

		headerAmountInDollarsLabel.font = .PinoStyle.mediumBody
		headerAmountInDollarsLabel.text = borrowLoanDetailsVM.tokenBorrowAmountInDollars
	}

	private func setupConstraints() {
		headerTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
		headerAmountInDollarsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		mainStackView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
		headerStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 16))
		headerTitleImage.pin(.fixedWidth(50), .fixedHeight(50))
		borderView.pin(.fixedHeight(1))
		contentStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 18))
		buttonsStackView.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: layoutMarginsGuide, padding: 20)
		)
	}

	private func setupBindings() {
		borrowLoanDetailsVM.$apy.compactMap { $0 }.sink { apyAmount in
			self.updateAPY(apyAmount: apyAmount)
		}.store(in: &cancellables)
	}

	private func updateAPY(apyAmount: String) {
		apyStackView.infoLabel.text = apyAmount
		apyStackView.infoLabel.textAlignment = .right
		hideSkeletonView()
		switch borrowLoanDetailsVM.apyVolatilityType {
		case .profit:
			apyStackView.infoLabel.textColor = .Pino.green
		case .loss:
			apyStackView.infoLabel.textColor = .Pino.red
		case nil:
			return
		case .some(.none):
			apyStackView.infoLabel.textColor = .Pino.secondaryLabel
		}
	}

	private func setupSkeletonView() {
		apyStackView.infoLabel.isSkeletonable = true
	}

	@objc
	private func onIncreaseBorrowButtonTap() {
		pushToBorrowIncreaseAmountPageClosure()
	}

	@objc
	private func onRepayButtonTap() {
		pushToRepayAmountPageClosure()
	}
}

//
//  InvestConfirmationView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import Combine
import UIKit

class InvestConfirmationView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let tokenCardView = PinoContainerCard()
	private let investInfoCardView = PinoContainerCard()
	private let tokenStackView = UIStackView()
	private let tokenImageView = UIImageView()
	private let tokenAmountStackView = UIStackView()
	private let investAmountLabel = UILabel()
	private let investAmountInDollarLabel = UILabel()
	private let investInfoStackView = UIStackView()
	private let selectedProtocolStackView = UIStackView()
	private let feeStackView = UIStackView()
	private var selectedProtocolTitleView: TitleWithInfo!
	private var feeTitleView: TitleWithInfo!
	private let protocolInfoStackView = UIStackView()
	private let protocolImageView = UIImageView()
	private let protoclNameLabel = UILabel()
	private let selectedProtocolSpacerView = UIView()
	private let feeSpacerView = UIView()
	private let feeResultView = UIView()
	private let feeErrorIcon = UIImageView()
	private let feeErrorLabel = UILabel()
	private let feeErrorStackView = UIStackView()
	private let feeLabel = UILabel()

	private let continueButton = PinoButton(style: .active)
	private let confirmButtonDidTap: () -> Void
	private let infoActionSheetDidTap: (InfoActionSheet) -> Void
	private let feeCalculationRetry: () -> Void
	private var investConfirmationVM: InvestConfirmationProtocol!
	private var cancellables = Set<AnyCancellable>()
	private var showFeeInDollar = true

	// MARK: - Initializers

	init(
		investConfirmationVM: InvestConfirmationProtocol,
		confirmButtonDidTap: @escaping () -> Void,
		infoActionSheetDidTap: @escaping (InfoActionSheet) -> Void,
		feeCalculationRetry: @escaping () -> Void
	) {
		self.investConfirmationVM = investConfirmationVM
		self.confirmButtonDidTap = confirmButtonDidTap
		self.infoActionSheetDidTap = infoActionSheetDidTap
		self.feeCalculationRetry = feeCalculationRetry
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
		feeTitleView = TitleWithInfo(
			actionSheetTitle: investConfirmationVM.feeInfoActionSheetTitle,
			actionSheetDescription: investConfirmationVM.feeInfoActionSheetDescription
		)

		selectedProtocolTitleView = TitleWithInfo(
			actionSheetTitle: investConfirmationVM.protocolInfoActionSheetTitle,
			actionSheetDescription: investConfirmationVM.protocolInfoActionSheetDescription
		)

		addSubview(contentStackview)
		addSubview(continueButton)
		contentStackview.addArrangedSubview(tokenCardView)
		contentStackview.addArrangedSubview(investInfoCardView)
		tokenCardView.addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(tokenImageView)
		tokenStackView.addArrangedSubview(tokenAmountStackView)
		tokenAmountStackView.addArrangedSubview(investAmountLabel)
		tokenAmountStackView.addArrangedSubview(investAmountInDollarLabel)
		investInfoCardView.addSubview(investInfoStackView)
		investInfoStackView.addArrangedSubview(selectedProtocolStackView)
		investInfoStackView.addArrangedSubview(feeStackView)
		selectedProtocolStackView.addArrangedSubview(selectedProtocolTitleView)
		selectedProtocolStackView.addArrangedSubview(selectedProtocolSpacerView)
		selectedProtocolStackView.addArrangedSubview(protocolInfoStackView)
		protocolInfoStackView.addArrangedSubview(protocolImageView)
		protocolInfoStackView.addArrangedSubview(protoclNameLabel)

		feeStackView.addArrangedSubview(feeTitleView)
		feeStackView.addArrangedSubview(feeSpacerView)
		feeStackView.addArrangedSubview(feeResultView)
		feeResultView.addSubview(feeErrorStackView)
		feeResultView.addSubview(feeLabel)
		feeErrorStackView.addArrangedSubview(feeErrorIcon)
		feeErrorStackView.addArrangedSubview(feeErrorLabel)

		let feeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleShowFee))
		feeLabel.addGestureRecognizer(feeLabelTapGesture)
		feeLabel.isUserInteractionEnabled = true

		continueButton.addAction(UIAction(handler: { _ in
			self.continueButton.style = .loading
			self.confirmButtonDidTap()
		}), for: .touchUpInside)

		feeTitleView.presentActionSheet = { feeInfoActionSheet in
			self.infoActionSheetDidTap(feeInfoActionSheet)
		}

		selectedProtocolTitleView.presentActionSheet = { feeInfoActionSheet in
			self.infoActionSheetDidTap(feeInfoActionSheet)
		}

		let feeRetryTapGesture = UITapGestureRecognizer(target: self, action: #selector(getFee))
		feeErrorStackView.addGestureRecognizer(feeRetryTapGesture)
	}

	private func setupStyle() {
		investAmountLabel.text = investConfirmationVM.formattedTransactionAmount
		investAmountInDollarLabel.text = investConfirmationVM.formattedTransactionAmountInDollar
		selectedProtocolTitleView.title = investConfirmationVM.selectedProtocolTitle
		protoclNameLabel.text = investConfirmationVM.selectedProtocolName
		feeTitleView.title = investConfirmationVM.feeTitle
		continueButton.title = investConfirmationVM.confirmButtonTitle
		feeErrorLabel.text = investConfirmationVM.feeErrorText
		feeErrorIcon.image = UIImage(named: investConfirmationVM.feeErrorIcon)

		protocolImageView.image = UIImage(named: investConfirmationVM.selectedProtocolImage)

		if investConfirmationVM.isTokenVerified {
			tokenImageView.kf.indicatorType = .activity
			tokenImageView.kf.setImage(with: investConfirmationVM.tokenImage)
			investAmountInDollarLabel.isHidden = false
		} else {
			tokenImageView.image = UIImage(named: investConfirmationVM.customAssetImage)
			investAmountInDollarLabel.isHidden = true
		}

		investAmountLabel.font = .PinoStyle.semiboldTitle2
		investAmountInDollarLabel.font = .PinoStyle.mediumBody
		protoclNameLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		feeErrorLabel.font = .PinoStyle.mediumBody

		investAmountLabel.textColor = .Pino.label
		investAmountInDollarLabel.textColor = .Pino.secondaryLabel
		protoclNameLabel.textColor = .Pino.label
		feeLabel.textColor = .Pino.label
		feeErrorLabel.textColor = .Pino.red
		feeErrorIcon.tintColor = .Pino.red

		backgroundColor = .Pino.background

		feeLabel.textAlignment = .right

		tokenStackView.axis = .vertical
		tokenAmountStackView.axis = .vertical
		investInfoStackView.axis = .vertical
		contentStackview.axis = .vertical

		tokenStackView.alignment = .center
		tokenAmountStackView.alignment = .center
		protocolInfoStackView.alignment = .center

		contentStackview.spacing = 16
		tokenStackView.spacing = 16
		tokenAmountStackView.spacing = 10
		investInfoStackView.spacing = 26
		protocolInfoStackView.spacing = 4
		feeErrorStackView.spacing = 4

		feeLabel.layer.masksToBounds = true
		feeLabel.layer.cornerRadius = 12
		tokenImageView.layer.cornerRadius = 25
		tokenImageView.layer.masksToBounds = true

		continueButton.style = .deactive
		feeErrorStackView.isHidden = true
		feeLabel.isSkeletonable = true
		showSkeletonView()
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 25)
		)
		tokenStackView.pin(
			.allEdges(padding: 16)
		)
		investInfoStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 24)
		)
		continueButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		tokenImageView.pin(
			.fixedWidth(50),
			.fixedHeight(50)
		)
		protocolImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		feeErrorIcon.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		feeTitleView.pin(
			.fixedWidth(48)
		)
		feeLabel.pin(
			.verticalEdges,
			.trailing
		)
		feeErrorStackView.pin(
			.allEdges
		)
		NSLayoutConstraint.activate([
			feeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
			feeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: feeResultView.leadingAnchor),
		])
	}

	private func setupBindings() {
		Publishers.Zip(
			investConfirmationVM.formattedFeeInDollarPublisher,
			investConfirmationVM.formattedFeeInETHPublisher
		).sink { [weak self] feeInDollar, feeInETH in
			guard let self, let feeInETH, let feeInDollar else { return }
			self.showEstimatedFee(feeInETH: feeInETH, feeInDollar: feeInDollar)
		}.store(in: &cancellables)
	}

	private func checkBalanceEnough() {
		if investConfirmationVM.userBalanceIsEnough {
			continueButton.style = .active
			continueButton.setTitle(investConfirmationVM.confirmButtonTitle, for: .normal)
		} else {
			continueButton.style = .deactive
			continueButton.setTitle(investConfirmationVM.insuffientButtonTitle, for: .normal)
		}

		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Environment.current != .mainNet {
			continueButton.style = .active
		}
	}

	private func showEstimatedFee(feeInETH: String, feeInDollar: String) {
		hideSkeletonView()
		feeLabel.layer.cornerRadius = 0
		updateFeeLabel(feeInEth: feeInETH, feeInDollar: feeInDollar)
		checkBalanceEnough()
	}

	private func updateFeeLabel(feeInEth: String, feeInDollar: String) {
		if showFeeInDollar {
			feeLabel.text = feeInDollar
		} else {
			feeLabel.text = feeInEth.ethFormatting
		}
	}

	@objc
	private func toggleShowFee() {
		guard let feeInETH = investConfirmationVM.formattedFeeInETH,
		      let feeInDollar = investConfirmationVM.formattedFeeInDollar else { return }
		showFeeInDollar.toggle()
		updateFeeLabel(feeInEth: feeInETH, feeInDollar: feeInDollar)
	}

	@objc
	private func getFee() {
		feeCalculationRetry()
	}

	// MARK: - Public Methods

	public func showfeeCalculationError() {
		feeLabel.isHidden = true
		feeErrorStackView.isHidden = false
	}

	public func hideFeeCalculationError() {
		feeErrorStackView.isHidden = true
		feeLabel.isHidden = false
	}
}

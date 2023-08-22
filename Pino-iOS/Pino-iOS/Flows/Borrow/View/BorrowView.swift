//
//  BorrowView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/19/23.
//
import Combine
import UIKit

class BorrowView: UIView {
	// MARK: - Closures

	public var presentHealthScoreActionsheet: (_ actionSheet: InfoActionSheet) -> Void

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let healthScoreContainerView = PinoContainerCard()
	private let healthScoreStackView = UIStackView()
	private let healthScoreTitleStackView = UIStackView()
	private let healthScoreBetweenView = UIView()
	private let healthScoreStatusDotView = UIView()
	private let healthScoreNumberLabel = UILabel()
	private var startBorrowView: StartBorrowingView!
	private var startCollateralView: StartBorrowingView!
	private var selectDexProtocolView: SelectDexSystemView!
	private var healthScoreTitleAndInfoView: TitleWithInfo!
	private var collateralDetailsView: BorrowingDetailsView!
	private var borrowDetailsView: BorrowingDetailsView!
	private var borrowVM: BorrowViewModel
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel, presentHealthScoreActionsheet: @escaping (_ actionSheet: InfoActionSheet) -> Void) {
		self.borrowVM = borrowVM
		self.presentHealthScoreActionsheet = presentHealthScoreActionsheet

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		#warning("this should open selectDexProtocolVC")
		selectDexProtocolView = SelectDexSystemView(
			title: borrowVM.selectedDexSystem.name,
			image: borrowVM.selectedDexSystem.image,
			onDexProtocolTapClosure: {}
		)

		healthScoreTitleAndInfoView = TitleWithInfo(
			actionSheetTitle: borrowVM.healthScoreTitle,
			actionSheetDescription: borrowVM.healthScoreTooltip
		)
		healthScoreTitleAndInfoView.presentActionSheet = { actionSheet in
			self.presentHealthScoreActionsheet(actionSheet)
		}

		#warning("didTapactionButton closure should open another page later")
		startBorrowView = StartBorrowingView(
			titleText: borrowVM.borrowTitle,
			descriptionText: borrowVM.borrowDescription,
			buttonTitleText: borrowVM.borrowTitle,
			didTapActionButtonClosure: {}
		)
		startCollateralView = StartBorrowingView(
			titleText: borrowVM.collateralTitle,
			descriptionText: borrowVM.collateralDescription,
			buttonTitleText: borrowVM.collateralTitle,
			didTapActionButtonClosure: {}
		)

		#warning("global assets list in mock")
		borrowDetailsView =
			BorrowingDetailsView(borrowingDetailsVM: BorrowingDetailsViewModel(borrowVM: borrowVM, borrowingType: .borrow))
		collateralDetailsView =
			BorrowingDetailsView(borrowingDetailsVM: BorrowingDetailsViewModel(
				borrowVM: borrowVM,
				borrowingType: .collateral
			))

		healthScoreTitleStackView.addArrangedSubview(healthScoreStatusDotView)
		healthScoreTitleStackView.addArrangedSubview(healthScoreTitleAndInfoView)

		healthScoreContainerView.addSubview(healthScoreStackView)

		healthScoreStackView.addArrangedSubview(healthScoreTitleStackView)
		healthScoreStackView.addArrangedSubview(healthScoreBetweenView)
		healthScoreStackView.addArrangedSubview(healthScoreNumberLabel)

		mainStackView.addArrangedSubview(selectDexProtocolView)
		mainStackView.addArrangedSubview(healthScoreContainerView)
		mainStackView.addArrangedSubview(startCollateralView)
		mainStackView.addArrangedSubview(collateralDetailsView)
		mainStackView.addArrangedSubview(startBorrowView)
		mainStackView.addArrangedSubview(borrowDetailsView)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.setCustomSpacing(8, after: healthScoreContainerView)
		mainStackView.setCustomSpacing(16, after: startCollateralView)
		mainStackView.setCustomSpacing(16, after: collateralDetailsView)

		healthScoreTitleAndInfoView.title = borrowVM.healthScoreTitle
		healthScoreTitleAndInfoView.customTextFont = .PinoStyle.mediumSubheadline
		healthScoreTitleAndInfoView.customTextColor = .Pino.label

		healthScoreStackView.axis = .horizontal
		healthScoreStackView.alignment = .center

		healthScoreTitleStackView.axis = .horizontal
		healthScoreTitleStackView.spacing = 6
		healthScoreTitleStackView.alignment = .center

		healthScoreStatusDotView.layer.cornerRadius = 7

		healthScoreNumberLabel.font = .PinoStyle.semiboldSubheadline
	}

	private func setupConstraints() {
		healthScoreNumberLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
		healthScoreStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
		healthScoreTitleStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true

		mainStackView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
		healthScoreStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 8))
		healthScoreStatusDotView.pin(.fixedWidth(14), .fixedHeight(14))
	}

	private func setupBindings() {
		borrowVM.$userBorrowingDetails.sink { userBorrowingDetails in
			guard let newUserBorrowingDetails = userBorrowingDetails else {
				return
			}
			self.updateHealthScoreValue(healthScore: newUserBorrowingDetails.healthScore)
			self.updateHealthScoreColors(healthScore: newUserBorrowingDetails.healthScore)
			self.updatePageStatus(userBorrowingDetails: newUserBorrowingDetails)
		}.store(in: &cancellables)
	}

	private func updatePageStatus(userBorrowingDetails: UserBorrowingModel) {
		if userBorrowingDetails.borrowTokens.isEmpty && userBorrowingDetails.collateralTokens.isEmpty {
			startBorrowView.isHidden = true
			borrowDetailsView.isHidden = false
			startCollateralView.isHidden = false
			collateralDetailsView.isHidden = true
		} else if userBorrowingDetails.borrowTokens.isEmpty && !userBorrowingDetails.collateralTokens.isEmpty {
			startBorrowView.isHidden = false
			borrowDetailsView.isHidden = true
			startCollateralView.isHidden = true
			collateralDetailsView.isHidden = false
		} else {
			startBorrowView.isHidden = true
			borrowDetailsView.isHidden = false
			startCollateralView.isHidden = true
			collateralDetailsView.isHidden = false
		}
	}

	private func updateHealthScoreValue(healthScore: Double) {
		healthScoreNumberLabel.text = healthScore.description
		healthScoreNumberLabel.numberOfLines = 0
	}

	private func updateHealthScoreColors(healthScore: Double) {
		if healthScore == 0 {
			healthScoreStatusDotView.backgroundColor = .Pino.red
			healthScoreNumberLabel.textColor = .Pino.red
		} else if healthScore > 0 && healthScore < 10 {
			healthScoreStatusDotView.backgroundColor = .Pino.orange
			healthScoreNumberLabel.textColor = .Pino.orange
		} else {
			healthScoreStatusDotView.backgroundColor = .Pino.green
			healthScoreNumberLabel.textColor = .Pino.green
		}
	}
}

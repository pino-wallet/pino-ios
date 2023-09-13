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

	public var presentHealthScoreActionsheet: (_ actionSheet: HealthScoreSystemViewModel) -> Void
	public var presentSelectDexSystem: () -> Void
	public var presentBorrowingBoardVC: () -> Void
	public var presentCollateralizingBoardVC: () -> Void

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let healthScoreContainerView = PinoContainerCard()
	private let healthScoreStackView = UIStackView()
	private let healthScoreTitleStackView = UIStackView()
	private let healthScoreBetweenView = UIView()
	private let healthScoreStatusDotView = UIView()
	private let healthScoreNumberLabel = UILabel()
	private let healthScoreInfoStackView = UIStackView()
	private let healthScoreTitleLabel = PinoLabel(style: .info, text: "")
	private let healthScoreInfoImageView = UIImageView()
	private var startBorrowView: StartBorrowingView!
	private var startCollateralView: StartBorrowingView!
	private var selectDexSystemView: SelectDexSystemView!
	private var collateralDetailsView: BorrowingDetailsView!
	private var borrowDetailsView: BorrowingDetailsView!
	private var borrowVM: BorrowViewModel
	private var healthScoreTitleStackViewHeightConstraint: NSLayoutConstraint!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		borrowVM: BorrowViewModel,
		presentHealthScoreActionsheet: @escaping (_ actionSheet: HealthScoreSystemViewModel) -> Void,
		presentSelectDexSystem: @escaping () -> Void,
		presentBorrowingBoardVC: @escaping () -> Void,
		presentCollateralizingBoardVC: @escaping () -> Void
	) {
		self.borrowVM = borrowVM
		self.presentHealthScoreActionsheet = presentHealthScoreActionsheet
		self.presentSelectDexSystem = presentSelectDexSystem
		self.presentBorrowingBoardVC = presentBorrowingBoardVC
		self.presentCollateralizingBoardVC = presentCollateralizingBoardVC

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
		setupSkeletonViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	public func showLoading() {
		healthScoreTitleStackViewHeightConstraint.isActive = true
		borrowDetailsView.showLoading()
		collateralDetailsView.showLoading()
		healthScoreContainerView.showSkeletonView()
		selectDexSystemView.isLoading = true
		healthScoreNumberLabel.isHidden = true
	}

	public func hideLoading() {
		healthScoreTitleStackViewHeightConstraint.isActive = false
		borrowDetailsView.hideLoading()
		collateralDetailsView.hideLoading()
		healthScoreContainerView.hideSkeletonView()
		selectDexSystemView.isLoading = false
		healthScoreNumberLabel.isHidden = false
	}

	// MARK: - Private Methods

	private func setupView() {
		let healthScoreTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(presentBorrowHealthScoreSystem)
		)
		healthScoreInfoImageView.addGestureRecognizer(healthScoreTapGesture)

		#warning("this should open selectDexProtocolVC")
		selectDexSystemView = SelectDexSystemView(
			title: borrowVM.selectedDexSystem.name,
			image: borrowVM.selectedDexSystem.image,
			onDexProtocolTapClosure: {
				self.presentSelectDexSystem()
			}
		)

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
			BorrowingDetailsView(
				borrowingDetailsVM: BorrowingDetailsViewModel(borrowVM: borrowVM, borrowingType: .borrow),
				onTapped: {
					self.presentBorrowingBoardVC()
				}
			)
		collateralDetailsView =
			BorrowingDetailsView(borrowingDetailsVM: BorrowingDetailsViewModel(
				borrowVM: borrowVM,
				borrowingType: .collateral
			), onTapped: {
				self.presentCollateralizingBoardVC()
			})

		healthScoreInfoStackView.addArrangedSubview(healthScoreTitleLabel)
		healthScoreInfoStackView.addArrangedSubview(healthScoreInfoImageView)

		healthScoreTitleStackView.addArrangedSubview(healthScoreStatusDotView)
		healthScoreTitleStackView.addArrangedSubview(healthScoreInfoStackView)

		healthScoreContainerView.addSubview(healthScoreStackView)

		healthScoreStackView.addArrangedSubview(healthScoreTitleStackView)
		healthScoreStackView.addArrangedSubview(healthScoreBetweenView)
		healthScoreStackView.addArrangedSubview(healthScoreNumberLabel)

		mainStackView.addArrangedSubview(selectDexSystemView)
		mainStackView.addArrangedSubview(healthScoreContainerView)
		mainStackView.addArrangedSubview(startCollateralView)
		mainStackView.addArrangedSubview(collateralDetailsView)
		mainStackView.addArrangedSubview(startBorrowView)
		mainStackView.addArrangedSubview(borrowDetailsView)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		healthScoreInfoImageView.isUserInteractionEnabled = true

		backgroundColor = .Pino.background

		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.setCustomSpacing(8, after: healthScoreContainerView)
		mainStackView.setCustomSpacing(16, after: startCollateralView)
		mainStackView.setCustomSpacing(16, after: collateralDetailsView)

		healthScoreInfoStackView.axis = .horizontal
		healthScoreInfoStackView.spacing = 2

		healthScoreTitleLabel.font = .PinoStyle.mediumSubheadline
		healthScoreTitleLabel.text = borrowVM.healthScoreTitle

		healthScoreInfoImageView.image = UIImage(named: borrowVM.alertIconName)

		healthScoreStackView.axis = .horizontal
		healthScoreStackView.alignment = .center

		healthScoreTitleStackView.axis = .horizontal
		healthScoreTitleStackView.spacing = 6
		healthScoreTitleStackView.alignment = .center

		healthScoreStatusDotView.layer.cornerRadius = 7

		healthScoreNumberLabel.font = .PinoStyle.semiboldSubheadline
	}

	private func setupConstraints() {
		healthScoreTitleStackViewHeightConstraint = healthScoreTitleStackView.heightAnchor
			.constraint(equalToConstant: 13)

		healthScoreNumberLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
		healthScoreStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

		mainStackView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(to: layoutMarginsGuide, padding: 0)
		)
		healthScoreStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 8))
		healthScoreStatusDotView.pin(.fixedWidth(14), .fixedHeight(14))
		healthScoreInfoImageView.pin(.fixedWidth(16), .fixedHeight(16))
	}

	private func setupBindings() {
		borrowVM.$userBorrowingDetails.sink { userBorrowingDetails in
			guard let newUserBorrowingDetails = userBorrowingDetails else {
				self.showCollateralAndBorrowDetails()
				self.showLoading()
				return
			}
			self.hideLoading()
			self.updateHealthScoreValue(healthScore: newUserBorrowingDetails.healthScore)
			self.updateHealthScoreColors(healthScore: newUserBorrowingDetails.healthScore)
			self.updatePageStatus(userBorrowingDetails: newUserBorrowingDetails)
		}.store(in: &cancellables)

		borrowVM.$selectedDexSystem.sink { selectedDexSystem in
			self.selectDexSystemView.titleText = selectedDexSystem.name
			self.selectDexSystemView.imageName = selectedDexSystem.image
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
			showCollateralAndBorrowDetails()
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

	private func showCollateralAndBorrowDetails() {
		startBorrowView.isHidden = true
		borrowDetailsView.isHidden = false
		startCollateralView.isHidden = true
		collateralDetailsView.isHidden = false
	}

	private func setupSkeletonViews() {
		healthScoreTitleStackView.isSkeletonable = true
	}

	@objc
	private func presentBorrowHealthScoreSystem() {
		guard let currentHealthScore = borrowVM.userBorrowingDetails?.healthScore else {
			return
		}
		let healthScoreSystemVM = HealthScoreSystemViewModel(healthScoreNumber: currentHealthScore)
		presentHealthScoreActionsheet(healthScoreSystemVM)
	}
}

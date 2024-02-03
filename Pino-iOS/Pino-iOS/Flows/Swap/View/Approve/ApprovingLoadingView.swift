//
//  ApprovingContractLoadingView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/24/23.
//

import Combine
import Foundation
import UIKit

class ApprovingLoadingView: UIView {
	// MARK: - Closures

	private var dismissPage: () -> Void
	private var presentActionSheet: (_ actionSheet: UIAlertController, _ completion: (() -> Void)?) -> Void

	// MARK: - Private Properties

	private let approvngContractLoadingVM: ApprovingLoadingViewModel!
	private let clearNavigationBar = ClearNavigationBar()
	private let clearNavigationBarRightSideView = UIView()
	private let navigationBarDismissButton = UIButton()
	private let warningTitleImageView = UIImageView()
	private let tryAgainButton = PinoButton(style: .active)
	private let speedUpDescriptionContainerView = UIView()
	private let speedUpDescriptionStackView = UIStackView()
	private let speedUpDescriptionAlertImageView = UIImageView()
	private let speedUpDescriptionLabel = PinoLabel(style: .description, text: "")
	private let loading = PinoLoading(size: 50)
	private let loadingTextLabel = PinoLabel(style: .title, text: "")
	private let loadingDescriptionLabel = PinoLabel(style: .info, text: "")
	private var speedUpButton: PinoRightSideImageButton!
	private var speedUpActionSheet: ApproveSpeedUpViewController!
	private let loadingStackView = UIStackView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		approvingLoadingVM: ApprovingLoadingViewModel,
		dismissPage: @escaping () -> Void,
		presentActionSheet: @escaping (_ actionSheet: UIAlertController, _ completion: (() -> Void)?) -> Void
	) {
		self.approvngContractLoadingVM = approvingLoadingVM
		self.dismissPage = dismissPage
		self.presentActionSheet = presentActionSheet

		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
		updateViewWithStatus(status: approvingLoadingVM.approveLoadingStatus)
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		speedUpButton = PinoRightSideImageButton(imageName: approvngContractLoadingVM.speedUpImageName, style: .primary)

		navigationBarDismissButton.addTarget(self, action: #selector(onDismissTap), for: .touchUpInside)

		tryAgainButton.addTarget(self, action: #selector(onTryAgainTap), for: .touchUpInside)

		speedUpButton.addTarget(self, action: #selector(openSpeedUpActionSheet), for: .touchUpInside)

		loadingStackView.addSubview(loading)

		loadingStackView.addArrangedSubview(warningTitleImageView)
		loadingStackView.addArrangedSubview(loading)
		loadingStackView.addArrangedSubview(loadingTextLabel)
		loadingStackView.addArrangedSubview(loadingDescriptionLabel)

		speedUpDescriptionStackView.addArrangedSubview(speedUpDescriptionAlertImageView)
		speedUpDescriptionStackView.addArrangedSubview(speedUpDescriptionLabel)

		speedUpDescriptionContainerView.addSubview(speedUpDescriptionStackView)

		clearNavigationBarRightSideView.addSubview(navigationBarDismissButton)

		clearNavigationBar.setRightSectionView(view: clearNavigationBarRightSideView)

		addSubview(clearNavigationBar)
		addSubview(loadingStackView)
		addSubview(speedUpDescriptionContainerView)
		addSubview(tryAgainButton)
		addSubview(speedUpButton)
	}

	private func setupStyle() {
		speedUpButton.title = approvngContractLoadingVM.speedUpButtonText

		tryAgainButton.title = approvngContractLoadingVM.tryAgainButtonText

		warningTitleImageView.image = UIImage(named: approvngContractLoadingVM.warningImageName)

		speedUpDescriptionAlertImageView.image = UIImage(named: approvngContractLoadingVM.grayErrorAlertImageName)

		navigationBarDismissButton.setImage(
			UIImage(named: approvngContractLoadingVM.dismissButtonImageName),
			for: .normal
		)

		backgroundColor = .Pino.secondaryBackground

		loadingTextLabel.font = .PinoStyle.semiboldTitle2

		loadingStackView.axis = .vertical
		loadingStackView.spacing = 24
		loadingStackView.alignment = .center
		loadingStackView.setCustomSpacing(8, after: loadingTextLabel)

		speedUpDescriptionStackView.axis = .horizontal
		speedUpDescriptionStackView.spacing = 4
		speedUpDescriptionStackView.alignment = .top

		loadingDescriptionLabel.textColor = .Pino.secondaryLabel

		speedUpDescriptionContainerView.backgroundColor = .Pino.webBackground
		speedUpDescriptionContainerView.layer.cornerRadius = 8

		speedUpDescriptionLabel.textColor = .Pino.label
		speedUpDescriptionLabel.text = approvngContractLoadingVM.speedUpDescriptionText
	}

	private func setupBindings() {
		approvngContractLoadingVM.$approveLoadingStatus.sink { approveLoadingStatus in
			self.updateViewWithStatus(status: approveLoadingStatus)
		}.store(in: &cancellables)
	}

	private func updateViewWithStatus(status: ApprovingLoadingViewModel.ApproveLoadingStatuses) {
		switch status {
		case .normalLoading:
			loading.isHidden = false
			loading.loadingSpeed = .normal
			loading.imageType = .primary
			warningTitleImageView.isHidden = true
			speedUpButton.isHidden = true
			speedUpDescriptionContainerView.isHidden = true
			tryAgainButton.isHidden = true
			navigationBarDismissButton.isHidden = true
			setLoadingTextLabel(text: approvngContractLoadingVM.approvingText)
			setLoadingDescriptionLabelText(text: approvngContractLoadingVM.takeFewSecondsText)
		case .showSpeedUp:
			loading.isHidden = false
			loading.loadingSpeed = .normal
			loading.imageType = .primary
			warningTitleImageView.isHidden = true
			navigationBarDismissButton.isHidden = false
			tryAgainButton.isHidden = true
            #warning("speed up will come back after v1")
//			speedUpDescriptionContainerView.isHidden = false
//			speedUpButton.isHidden = false
			setLoadingTextLabel(text: approvngContractLoadingVM.approvingText)
			setLoadingDescriptionLabelText(text: approvngContractLoadingVM.takeFewMinutesText)
		case .fastLoading:
			warningTitleImageView.isHidden = true
			loading.isHidden = false
			loading.loadingSpeed = .fast
			loading.imageType = .rainbow
			tryAgainButton.isHidden = true
			speedUpButton.isHidden = true
			navigationBarDismissButton.isHidden = true
			speedUpDescriptionContainerView.isHidden = true
			setLoadingTextLabel(text: approvngContractLoadingVM.approvingText)
			setLoadingDescriptionLabelText(text: approvngContractLoadingVM.takeFewSecondsText)
		case .error:
			navigationBarDismissButton.isHidden = false
			loading.isHidden = true
			warningTitleImageView.isHidden = false
			tryAgainButton.isHidden = false
			speedUpButton.isHidden = true
			speedUpDescriptionContainerView.isHidden = true
			setLoadingTextLabel(text: approvngContractLoadingVM.somethingWentWeongText)
			setLoadingDescriptionLabelText(text: approvngContractLoadingVM.tryAgainDescriptionText)
		case .done:
			return
		}
	}

	private func setLoadingDescriptionLabelText(text: String) {
		loadingDescriptionLabel.text = text
		loadingDescriptionLabel.numberOfLines = 0
		loadingDescriptionLabel.textAlignment = .center
	}

	private func setLoadingTextLabel(text: String) {
		loadingTextLabel.text = text
		loadingTextLabel.numberOfLines = 0
		loadingTextLabel.textAlignment = .center
	}

	private func setupContstraint() {
		loadingStackView.pin(
			.centerX,
			.centerY
		)
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		navigationBarDismissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		warningTitleImageView.pin(.fixedWidth(56), .fixedHeight(56))
		tryAgainButton.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: layoutMarginsGuide, padding: 12)
		)
		speedUpButton.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: layoutMarginsGuide, padding: 12)
		)
		speedUpDescriptionContainerView.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.relative(.bottom, -24, to: speedUpButton, .top)
		)
		speedUpDescriptionStackView.pin(.verticalEdges(padding: 10), .leading(padding: 8), .trailing(padding: 16))
		speedUpDescriptionAlertImageView.pin(.fixedWidth(20), .fixedHeight(20))
	}

	@objc
	private func onDismissTap() {
		dismissPage()
	}

	@objc
	private func onTryAgainTap() {
		approvngContractLoadingVM.approveToken()
	}

	@objc
	private func openSpeedUpActionSheet() {
		speedUpActionSheet = ApproveSpeedUpViewController(approveLoadingVM: approvngContractLoadingVM)
		presentActionSheet(speedUpActionSheet) {
			let speedUpAlertBackgroundTappedGesture = UITapGestureRecognizer(
				target: self,
				action: #selector(self.speedUpAlertBackgroundTapped)
			)
			self.speedUpActionSheet.view.superview?.subviews[0]
				.addGestureRecognizer(speedUpAlertBackgroundTappedGesture)
			self.speedUpActionSheet.view.superview?.subviews[0].isUserInteractionEnabled = true
		}
	}

	@objc
	private func speedUpAlertBackgroundTapped() {
		if speedUpActionSheet.isDismissable {
			speedUpActionSheet.dismiss(animated: true)
		}
	}
}

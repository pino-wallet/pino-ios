//
//  ApproveSpeedUpViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/16/23.
//

import Combine
import UIKit

class ApproveSpeedUpViewController: UIAlertController {
	// MARK: - Public Properties

	public var isDismissable = true

	// MARK: - Private Properties

	private let contentView = UIView()
	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleWarningImageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let feeStackView = UIStackView()
	private let speedUpArrowImageView = UIImageView()
	private let speedUpArrowImageContainerView = UIView()
	private let actionButton = PinoButton(style: .active)
	private let hapticManager = HapticManager()
	private var currentFeeView: GradientShowFeeView!
	private var speedUpFeeView: GradientShowFeeView!
	private var approveLoadingVM: ApprovingLoadingViewModel!
	private var cancellables = Set<AnyCancellable>()
	private var approveSpeedUpAlertVM: ApproveSpeedUpViewModel!
	private var loadingIndicator = PinoLoading(size: 50)
	private var pageStatus: pageStatuses = .feeLoading {
		didSet {
			updateUIWithPageStatus()
		}
	}

	private enum pageStatuses {
		case feeLoading
		case speedUpLoading
		case normal
		case error(ApproveSpeedupError)
	}

	// MARK: - Initializers

	convenience init(approveLoadingVM: ApprovingLoadingViewModel) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)

		self.approveLoadingVM = approveLoadingVM

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
	}

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
		speedUpFeeView.updateGradientColors([.Pino.green, .yellow, .Pino.orange, .purple])
		currentFeeView.updateGradientColors([.Pino.gray5, .Pino.gray5])
		pageStatus = .feeLoading
		approveSpeedUpAlertVM.getSpeedUpDetails()
	}

	// MARK: - Private Methods

	private func setupView() {
		approveSpeedUpAlertVM = ApproveSpeedUpViewModel(
			approveLoadingVM: approveLoadingVM,
			didSpeedUpTransaction: { error in
				if let error {
					self.pageStatus = .error(error)
				} else {
					self.dismiss(animated: true)
				}
			}
		)

		currentFeeView = GradientShowFeeView(
			titleText: approveLoadingVM.formattedFeeInDollar,
			descriptionText: approveSpeedUpAlertVM.currentFeeTitle
		)

		speedUpFeeView = GradientShowFeeView(titleText: "", descriptionText: approveSpeedUpAlertVM.speedUpFeeTitle)

		speedUpArrowImageContainerView.addSubview(speedUpArrowImageView)

		titleStackView.addArrangedSubview(titleWarningImageView)
		titleStackView.addArrangedSubview(titleLabel)

		feeStackView.addArrangedSubview(currentFeeView)
		feeStackView.addArrangedSubview(speedUpArrowImageView)
		feeStackView.addArrangedSubview(speedUpFeeView)

		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(descriptionLabel)
		mainStackView.addArrangedSubview(feeStackView)
		mainStackView.addArrangedSubview(actionButton)

		actionButton.addTarget(self, action: #selector(confirmSpeedUpTransaction), for: .touchUpInside)

		contentView.addSubview(mainStackView)
		contentView.addSubview(loadingIndicator)
		view.addSubview(contentView)
	}

	private func setupStyles() {
		overrideUserInterfaceStyle = .light

		feeStackView.axis = .horizontal
		feeStackView.alignment = .center
		feeStackView.spacing = 7

		speedUpArrowImageView.image = UIImage(named: approveSpeedUpAlertVM.speedUpArrow)

		contentView.backgroundColor = .Pino.secondaryBackground
		contentView.layer.cornerRadius = 16

		mainStackView.axis = .vertical
		mainStackView.spacing = 5

		titleStackView.axis = .horizontal
		titleStackView.spacing = 4
		titleStackView.alignment = .center

		titleWarningImageView.image = UIImage(named: approveSpeedUpAlertVM.errorImageName)
		titleWarningImageView.tintColor = .Pino.primary
	}

	private func setupConstraints() {
		contentView.pin(.allEdges(padding: 0))
		mainStackView.pin(.horizontalEdges(padding: 16), .verticalEdges(padding: 32))
		speedUpArrowImageView.pin(.fixedHeight(15))
		loadingIndicator.pin(.centerY(), .centerX())
		currentFeeView.pin(.fixedWidth(140))
		speedUpFeeView.pin(.fixedWidth(140))
		titleWarningImageView.pin(.fixedWidth(24), .fixedHeight(24))
	}

	private func setupBindings() {
		approveSpeedUpAlertVM.$speedUpFeeInDollars.sink { speedUpFeeInDollars in
			self.speedUpFeeView.titleText = speedUpFeeInDollars
			self.pageStatus = .normal
		}.store(in: &cancellables)
	}

	private func updateUIWithPageStatus() {
		switch pageStatus {
		case .feeLoading:
			speedUpFeeView.showSkeletonView()
			actionButton.style = .deactive
			actionButton.title = approveSpeedUpAlertVM.waitTitle
			titleLabel.text = approveSpeedUpAlertVM.title
			descriptionLabel.text = approveSpeedUpAlertVM.description
			mainStackView.setCustomSpacing(24, after: descriptionLabel)
			mainStackView.setCustomSpacing(40, after: feeStackView)
			mainStackView.setCustomSpacing(5, after: titleStackView)
			feeStackView.isHidden = false
			mainStackView.isHidden = false
			loadingIndicator.isHidden = true
			titleWarningImageView.isHidden = true
			isDismissable = true
		case .speedUpLoading:
			mainStackView.isHidden = true
			loadingIndicator.isHidden = false
			titleWarningImageView.isHidden = true
			isDismissable = false
		case .normal:
			speedUpFeeView.hideSkeletonView()
			actionButton.style = .active
			actionButton.title = approveSpeedUpAlertVM.confirmTitle
			mainStackView.isHidden = false
			loadingIndicator.isHidden = true
			titleWarningImageView.isHidden = true
			isDismissable = true
		case let .error(speedupError):
			showError(speedupError)
		}

		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Environment.current != .mainNet {
			actionButton.style = .active
		}
	}

	private func showError(_ error: ApproveSpeedupError) {
		mainStackView.isHidden = false
		loadingIndicator.isHidden = true
		isDismissable = true
		switch error {
		case .insufficientBalance:
			actionButton.style = .deactive
			actionButton.title = error.description
			titleWarningImageView.isHidden = true
		case .somethingWrong, .transactionExist:
			feeStackView.isHidden = true
			titleWarningImageView.isHidden = false
			mainStackView.setCustomSpacing(24, after: titleStackView)
			mainStackView.setCustomSpacing(48, after: descriptionLabel)
			titleLabel.text = approveSpeedUpAlertVM.errorTitle
			descriptionLabel.text = error.description
			actionButton.style = .active
			actionButton.title = approveSpeedUpAlertVM.gotItTitle
		}
	}

	@objc
	private func confirmSpeedUpTransaction() {
		hapticManager.run(type: .mediumImpact)
		switch pageStatus {
		case .normal:
			pageStatus = .speedUpLoading
			approveSpeedUpAlertVM.speedUpTransaction()
		case let .error(speedupError):
			if speedupError == .somethingWrong || speedupError == .transactionExist {
				dismiss(animated: true)
			}
		default: return
		}
	}
}

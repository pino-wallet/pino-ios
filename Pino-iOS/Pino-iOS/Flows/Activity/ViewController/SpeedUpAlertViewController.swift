//
//  SpeedUpActionSheet.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/13/23.
//

import Combine
import UIKit

class SpeedUpAlertViewController: UIAlertController {
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
	private var currentFeeView: GradientShowFeeView!
	private var speedUpFeeView: GradientShowFeeView!
	private var activityDetailsVM: ActivityDetailsViewModel!
	private var cancellables = Set<AnyCancellable>()
	private var speedUpAlertVM: SpeedUpAlertViewModel!
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
		case insufficientBalance
		case somethingWrong
		case transactionExist
	}

	// MARK: - Initializers

	convenience init(activityDetailsVM: ActivityDetailsViewModel) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)

		self.activityDetailsVM = activityDetailsVM

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
		speedUpAlertVM.getSpeedUpDetails()
	}

	// MARK: - Private Methods

	private func setupView() {
		speedUpAlertVM = SpeedUpAlertViewModel(activityDetailsVM: activityDetailsVM, didSpeedUpTransaction: { error in
                if error != nil {
                    switch error {
                    case .insufficientBalanceError:
                        if Environment.pinoNode != .mainNet {
                            self.pageStatus = .normal
                        } else {
                            self.pageStatus = .insufficientBalance
                        }
                    case .somethingWentWrong:
                        self.pageStatus = .somethingWrong
                    case .transactionExistError:
                        self.pageStatus = .transactionExist
                    default:
                        print("unknown error type")
                    }
                } else {
                    self.dismiss(animated: true)
                }
		})

		currentFeeView = GradientShowFeeView(
			titleText: activityDetailsVM.properties.formattedFeeInDollar,
			descriptionText: speedUpAlertVM.currentFeeTitle
		)

		speedUpFeeView = GradientShowFeeView(titleText: "", descriptionText: speedUpAlertVM.speedUpFeeTitle)

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

		speedUpArrowImageView.image = UIImage(named: speedUpAlertVM.speedUpArrow)

		contentView.backgroundColor = .Pino.secondaryBackground
		contentView.layer.cornerRadius = 16

		mainStackView.axis = .vertical
		mainStackView.spacing = 5

		titleStackView.axis = .horizontal
		titleStackView.spacing = 4
		titleStackView.alignment = .center

		titleWarningImageView.image = UIImage(named: speedUpAlertVM.errorImageName)
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
		speedUpAlertVM.$speedUpFeeInDollars.sink { speedUpFeeInDollars in
			self.speedUpFeeView.titleText = speedUpFeeInDollars
			self.pageStatus = .normal
		}.store(in: &cancellables)
	}

	private func updateUIWithPageStatus() {
		switch pageStatus {
		case .feeLoading:
			speedUpFeeView.showSkeletonView()
			actionButton.style = .deactive
			actionButton.title = speedUpAlertVM.waitTitle
			titleLabel.text = speedUpAlertVM.title
			descriptionLabel.text = speedUpAlertVM.description
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
			actionButton.title = speedUpAlertVM.confirmTitle
			mainStackView.isHidden = false
			loadingIndicator.isHidden = true
			titleWarningImageView.isHidden = true
			isDismissable = true
		case .insufficientBalance:
			actionButton.style = .deactive
			actionButton.title = speedUpAlertVM.insufficientBalanceTitle
			mainStackView.isHidden = false
			loadingIndicator.isHidden = true
			titleWarningImageView.isHidden = true
			isDismissable = true
		case .somethingWrong:
			mainStackView.isHidden = false
			loadingIndicator.isHidden = true
			feeStackView.isHidden = true
			titleWarningImageView.isHidden = false
			mainStackView.setCustomSpacing(24, after: titleStackView)
			mainStackView.setCustomSpacing(48, after: descriptionLabel)
			titleLabel.text = speedUpAlertVM.errorTitle
			descriptionLabel.text = speedUpAlertVM.errorSomethingWentWrong
			actionButton.style = .active
			actionButton.title = speedUpAlertVM.gotItTitle
			isDismissable = true
		case .transactionExist:
			mainStackView.isHidden = false
			loadingIndicator.isHidden = true
			feeStackView.isHidden = true
			titleWarningImageView.isHidden = false
			mainStackView.setCustomSpacing(24, after: titleStackView)
			mainStackView.setCustomSpacing(48, after: descriptionLabel)
			titleLabel.text = speedUpAlertVM.errorTitle
			descriptionLabel.text = speedUpAlertVM.errorTransactionExist
			actionButton.style = .active
			actionButton.title = speedUpAlertVM.gotItTitle
			isDismissable = true
		}
	}

	@objc
	private func confirmSpeedUpTransaction() {
		switch pageStatus {
		case .transactionExist:
			dismiss(animated: true)
		case .somethingWrong:
			dismiss(animated: true)
		case .normal:
			pageStatus = .speedUpLoading
			speedUpAlertVM.speedUpTransaction()
		default:
			return
		}
	}
}

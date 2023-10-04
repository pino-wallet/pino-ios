//
//  ApproveContractView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Foundation
import UIKit

class ApproveContractView: UIView {
	// MARK: - Closures

	public var onApproveTap: () -> Void

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let titleImageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let describtionLabel = PinoLabel(style: .info, text: "")
	private let learnMoreStackView = UIStackView()
	private let learnMoreLabel = UILabel()
	private let rightArrowImageView = UIImageView()
	private let approveButton = PinoButton(style: .active)
	private var approveContractVM: ApproveContractViewModel

	// MARK: - Initializers

	init(approveContractVM: ApproveContractViewModel, onApproveTap: @escaping () -> Void) {
		self.approveContractVM = approveContractVM
		self.onApproveTap = onApproveTap

		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		let learnMoreTapGesture = UITapGestureRecognizer(target: self, action: #selector(openLearnMorePage))
		learnMoreStackView.addGestureRecognizer(learnMoreTapGesture)

		approveButton.addTarget(self, action: #selector(onApproveButtonTap), for: .touchUpInside)

		learnMoreStackView.addArrangedSubview(learnMoreLabel)
		learnMoreStackView.addArrangedSubview(rightArrowImageView)

		contentStackView.addArrangedSubview(titleImageView)
		contentStackView.addArrangedSubview(titleLabel)
		contentStackView.addArrangedSubview(describtionLabel)
		contentStackView.addArrangedSubview(learnMoreStackView)

		containerView.addSubview(contentStackView)

		addSubview(containerView)
		addSubview(approveButton)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background

		contentStackView.axis = .vertical
		contentStackView.spacing = 10
		contentStackView.alignment = .center

		learnMoreStackView.axis = .horizontal
		learnMoreStackView.spacing = 2

		titleImageView.image = UIImage(named: approveContractVM.titleImageName)

		rightArrowImageView.image = UIImage(named: approveContractVM.rightArrowImageName)

		titleLabel.font = .PinoStyle.semiboldTitle2
		titleLabel.text = approveContractVM.pageTitle
		titleLabel.numberOfLines = 0

		describtionLabel.textColor = .Pino.secondaryLabel
		describtionLabel.text = generateApproveDescriptionLabelText()
		describtionLabel.textAlignment = .center
		describtionLabel.numberOfLines = 0

		learnMoreLabel.font = .PinoStyle.semiboldBody
		learnMoreLabel.textColor = .Pino.primary
		learnMoreLabel.text = approveContractVM.learnMoreButtonTitle
		learnMoreLabel.numberOfLines = 0

		approveButton.title = approveContractVM.approveButtonTitle
	}

	private func setupContstraint() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
		describtionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
		learnMoreLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		containerView.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.top(to: layoutMarginsGuide, padding: 24)
		)
		contentStackView.pin(.horizontalEdges(padding: 10), .verticalEdges(padding: 20))
		approveButton.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: layoutMarginsGuide, padding: 12)
		)
		titleImageView.pin(.fixedWidth(48), .fixedHeight(48))
		rightArrowImageView.pin(.fixedWidth(22), .fixedHeight(22))
	}

	#warning("Fill later with approve Info")
	private func generateApproveDescriptionLabelText() -> String {
		"Token Approve Info"
//		"\(approveContractVM.approveText) \(approveContractVM.selectedToken.symbol).
//		\(approveContractVM.approveDescriptionText)"
	}

	@objc
	private func openLearnMorePage() {
		let learnMoreURL = URL(string: approveContractVM.learnMoreURL)!
		UIApplication.shared.open(learnMoreURL)
	}

	@objc
	private func onApproveButtonTap() {
		approveButton.style = .loading
		onApproveTap()
	}
}

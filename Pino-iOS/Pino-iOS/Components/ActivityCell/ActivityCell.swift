//
//  CoinHistoryCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import UIKit

class ActivityCell: UICollectionViewCell {
	// MARK: - private Properties

	private let historyCardView = PinoContainerCard()
	private let contentStackView = UIStackView()
	private let historyIcon = UIImageView()
	private let historyTitleStackView = UIStackView()
	private let historyTitleContainer = UIView()
	private let historyTitleLabel = PinoLabel(style: .title, text: nil)
	private let historyTimeLabel = UILabel()
	private let statusStackView = UIStackView()
	private let statusLabelContainer = UIView()
	private let statusLabel = UILabel()

	// MARK: - public properties

	public static let cellID = "coinHistoryCell"

	public var activityCellVM: ActivityCellViewModelProtocol? {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			layoutIfNeeded()
			setupSkeletonView()
		}
	}

	// MARK: - private UI method

	private func setupView() {
		contentView.addSubview(historyCardView)
		statusLabelContainer.addSubview(statusLabel)
		historyCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(historyIcon)
		historyTitleContainer.addSubview(historyTitleStackView)
		contentStackView.addArrangedSubview(historyTitleContainer)
		historyTitleStackView.addArrangedSubview(historyTitleLabel)
		historyTitleStackView.addArrangedSubview(statusStackView)
		statusStackView.addArrangedSubview(historyTimeLabel)
		statusStackView.addArrangedSubview(statusLabelContainer)
	}

	private func setupStyle() {
		historyTitleLabel.text = activityCellVM?.title ?? ""
		historyTitleLabel.numberOfLines = 0
		historyTimeLabel.text = activityCellVM?.formattedTime ?? ""
		historyTimeLabel.numberOfLines = 0

		historyIcon.image = UIImage(named: activityCellVM?.icon ?? "unverified_asset")

		historyCardView.backgroundColor = .Pino.secondaryBackground
		historyIcon.backgroundColor = .Pino.background
		historyIcon.backgroundColor = .Pino.background

		historyTitleLabel.textColor = .Pino.label
		historyTimeLabel.textColor = .Pino.secondaryLabel

		historyTitleLabel.font = .PinoStyle.mediumCallout
		historyTimeLabel.font = .PinoStyle.mediumFootnote
		statusLabel.font = .PinoStyle.SemiboldCaption2

		contentStackView.axis = .horizontal
		historyTitleStackView.axis = .vertical
		statusStackView.axis = .horizontal

		contentStackView.spacing = 8
		historyTitleStackView.spacing = 12
		statusStackView.spacing = 4

		historyTitleStackView.alignment = .leading
		statusStackView.alignment = .center
		historyIcon.contentMode = .center
		statusLabel.textAlignment = .center
		contentStackView.alignment = .center

		historyIcon.layer.cornerRadius = 22
		historyIcon.layer.masksToBounds = true

		guard let activityStatus = activityCellVM?.status else {
			return
		}
            statusLabel.text = activityStatus.rawValue
		switch activityStatus {
		case .failed:
			statusLabelContainer.backgroundColor = .Pino.lightRed
			statusLabel.textColor = .Pino.red
			statusLabel.isHidden = false
			statusLabelContainer.isHidden = false
		case .pending:
			statusLabelContainer.backgroundColor = .Pino.lightOrange
			statusLabel.textColor = .Pino.pendingOrange
			statusLabel.isHidden = false
			statusLabelContainer.isHidden = false
		case .success:
			statusLabelContainer.isHidden = true
			statusLabel.isHidden = true
		}
	}

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		historyIcon.layer.cornerRadius = historyIcon.frame.height * 0.5
		statusLabelContainer.layer.cornerRadius = 10
		statusLabelContainer.layer.masksToBounds = true
	}

	private func setupConstraint() {
		historyTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 180).isActive = true
		historyTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
		historyTitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 220).isActive = true
		historyTimeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120).isActive = true

		historyTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 17).isActive = true
		historyTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14).isActive = true

		historyCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
		contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 46).isActive = true

		historyTitleStackView.pin(.leading(padding: 0), .verticalEdges(padding: 0))

		historyCardView.pin(
			.allEdges(padding: 0)
		)
		contentStackView.pin(
			.verticalEdges(padding: 9),
			.horizontalEdges(padding: 14)
		)
		historyIcon.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		statusLabelContainer.pin(.fixedHeight(20))
		statusLabel.pin(
			.fixedHeight(13),
			.horizontalEdges(padding: 6),
			.centerY()
		)
	}

	private func setupSkeletonView() {
		historyIcon.isSkeletonable = true
		historyTimeLabel.isSkeletonable = true
		historyTitleLabel.isSkeletonable = true
	}
}

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
	private let historyMoreInfoLabel = UILabel()
	private let historyMoreInfoLoadingContainer = UIView()
	private let statusStackView = UIStackView()
	private let pendingStatusLabelContainer = UIView()
	private let pendingStatusLabel = UILabel()
	private let failedStatusLabelContainer = UIView()
	private let failedStatusLabel = UILabel()
	private var titleLabelHeightConstraint: NSLayoutConstraint!
	private var infoLabelHeightConstraint: NSLayoutConstraint!

	// MARK: - public properties

	public static let cellID = "coinHistoryCell"

	public var activityCellVM: ActivityCellViewModelProtocol? {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			layoutIfNeeded()
			setupSkeletonView()
			performLoadingUIChanges()
		}
	}
    
    // MARK: - View Overrides
    
     override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabelHeightConstraint.constant = 0
        infoLabelHeightConstraint.constant = 0
    }

	// MARK: - private UI method

	private func setupView() {
		contentView.addSubview(historyCardView)
		failedStatusLabelContainer.addSubview(failedStatusLabel)
		pendingStatusLabelContainer.addSubview(pendingStatusLabel)
		historyCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(historyIcon)
		historyTitleContainer.addSubview(historyTitleStackView)
		contentStackView.addArrangedSubview(historyTitleContainer)
		historyTitleStackView.addArrangedSubview(historyTitleLabel)
		historyTitleStackView.addArrangedSubview(statusStackView)
		statusStackView.addArrangedSubview(historyMoreInfoLoadingContainer)
		statusStackView.addArrangedSubview(historyMoreInfoLabel)
		statusStackView.addArrangedSubview(pendingStatusLabelContainer)
		statusStackView.addArrangedSubview(failedStatusLabelContainer)
	}

	private func setupStyle() {
		historyTitleLabel.text = activityCellVM?.title
		historyTitleLabel.numberOfLines = 1
		historyTitleLabel.lineBreakMode = .byTruncatingTail
		historyMoreInfoLabel.text = activityCellVM?.activityMoreInfo
		historyMoreInfoLabel.numberOfLines = 1
		historyMoreInfoLabel.lineBreakMode = .byTruncatingTail

		historyIcon.image = UIImage(named: activityCellVM?.icon ?? "unverified_asset")

		historyCardView.backgroundColor = .Pino.secondaryBackground
		historyIcon.backgroundColor = .Pino.background
		historyIcon.backgroundColor = .Pino.background

		historyTitleLabel.textColor = .Pino.label
		historyMoreInfoLabel.textColor = .Pino.secondaryLabel

		historyTitleLabel.font = .PinoStyle.mediumCallout
		historyMoreInfoLabel.font = .PinoStyle.mediumFootnote
		failedStatusLabel.font = .PinoStyle.SemiboldCaption2
		pendingStatusLabel.font = .PinoStyle.SemiboldCaption2
		pendingStatusLabel.textColor = .Pino.pendingOrange

		contentStackView.axis = .horizontal
		historyTitleStackView.axis = .vertical
		statusStackView.axis = .horizontal

		contentStackView.spacing = 8
		historyTitleStackView.spacing = 14
		statusStackView.spacing = 4

		historyTitleStackView.alignment = .leading
		statusStackView.alignment = .center
		historyIcon.contentMode = .center
		failedStatusLabel.textAlignment = .center
		contentStackView.alignment = .center

		historyIcon.layer.cornerRadius = 22
		historyIcon.layer.masksToBounds = true

		if activityCellVM != nil {
			historyMoreInfoLoadingContainer.isHidden = true
			historyMoreInfoLabel.isHidden = false
		} else {
			historyMoreInfoLoadingContainer.isHidden = false
			historyMoreInfoLabel.isHidden = true
		}

		failedStatusLabelContainer.backgroundColor = .Pino.lightRed
		failedStatusLabel.textColor = .Pino.red

		pendingStatusLabelContainer.backgroundColor = .Pino.lightOrange

		pendingStatusLabel.text = ActivityCellStatus.pending.rawValue

		failedStatusLabel.text = ActivityCellStatus.failed.rawValue
		switch activityCellVM?.status {
		case .failed:
			failedStatusLabelContainer.isHidden = false
			pendingStatusLabelContainer.isHidden = true
		case .pending:
			failedStatusLabelContainer.isHidden = true
			pendingStatusLabelContainer.isHidden = false
		case .success:
			failedStatusLabelContainer.isHidden = true
			pendingStatusLabelContainer.isHidden = true
		default:
			failedStatusLabelContainer.isHidden = true
			pendingStatusLabelContainer.isHidden = true
		}
	}

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		historyIcon.layer.cornerRadius = historyIcon.frame.height * 0.5
		pendingStatusLabelContainer.layer.cornerRadius = 10
		pendingStatusLabelContainer.layer.masksToBounds = true
		failedStatusLabelContainer.layer.cornerRadius = 10
		failedStatusLabelContainer.layer.masksToBounds = true
	}

	private func setupConstraint() {
		titleLabelHeightConstraint = historyTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
		infoLabelHeightConstraint = historyMoreInfoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12)

		titleLabelHeightConstraint.isActive = true
		infoLabelHeightConstraint.isActive = true

		historyTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 130).isActive = true
		historyMoreInfoLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120).isActive = true
		historyMoreInfoLoadingContainer.widthAnchor.constraint(equalToConstant: 56).isActive = true
		historyMoreInfoLoadingContainer.heightAnchor.constraint(equalToConstant: 12).isActive = true

		historyCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
		contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 46).isActive = true

		historyTitleStackView.pin(.allEdges(padding: 0))

		historyCardView.pin(
			.allEdges(padding: 0),
			.fixedWidth(contentView.frame.width)
		)
		contentStackView.pin(
			.verticalEdges(padding: 9),
			.horizontalEdges(padding: 14)
		)
		historyIcon.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		pendingStatusLabelContainer.pin(.fixedHeight(20))
		failedStatusLabelContainer.pin(.fixedHeight(20))
		failedStatusLabel.pin(
			.fixedHeight(13),
			.horizontalEdges(padding: 6),
			.centerY
		)
		pendingStatusLabel.pin(
			.fixedHeight(13),
			.horizontalEdges(padding: 6),
			.centerY
		)
	}

	private func setupSkeletonView() {
		historyIcon.isSkeletonable = true
		historyMoreInfoLoadingContainer.isSkeletonable = true
		historyTitleLabel.isSkeletonable = true
	}

	private func performLoadingUIChanges() {
		if activityCellVM != nil {
			historyTitleStackView.spacing = 4
			titleLabelHeightConstraint.constant = 24
			infoLabelHeightConstraint.constant = 18
			layoutIfNeeded()
		} else {
			historyTitleStackView.spacing = 14
			titleLabelHeightConstraint.constant = 14
			infoLabelHeightConstraint.constant = 12
			layoutIfNeeded()
		}
	}
}

//
//  CoinHistoryCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import UIKit

class ActivityCell: UICollectionViewCell {
	// MARK: - private Properties

	private let historyCardView = UIView()
	private let contentStackView = UIStackView()
	private let historyIcon = UIImageView()
	private let historyTitleStackView = UIStackView()
	private let historyTitleLabel = PinoLabel(style: .title, text: nil)
	private let historyTimeLabel = UILabel()
	private let statusStackView = UIStackView()
    private let statusLabelContainer = UIView()
	private let statusLabel = UILabel()

	// MARK: - public properties

	public static let cellID = "coinHistoryCell"

	public var activityCellVM: ActivityCellViewModelProtocol! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			layoutIfNeeded()
		}
	}

	// MARK: - private UI method

	private func setupView() {
		contentView.addSubview(historyCardView)
        statusLabelContainer.addSubview(statusLabel)
		historyCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(historyIcon)
		contentStackView.addArrangedSubview(historyTitleStackView)
		historyTitleStackView.addArrangedSubview(historyTitleLabel)
		historyTitleStackView.addArrangedSubview(statusStackView)
		statusStackView.addArrangedSubview(historyTimeLabel)
		statusStackView.addArrangedSubview(statusLabelContainer)
	}

	private func setupStyle() {
		historyTitleLabel.text = activityCellVM.title
		historyTimeLabel.text = activityCellVM.formattedTime

		historyIcon.image = UIImage(named: activityCellVM.icon)

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

		contentStackView.spacing = 12
		historyTitleStackView.spacing = 8
		statusStackView.spacing = 4

		historyTitleStackView.alignment = .leading
		statusStackView.alignment = .center
		historyIcon.contentMode = .center
		statusLabel.textAlignment = .center

		switch activityCellVM.status {
		case .failed:
            statusLabelContainer.backgroundColor = .Pino.lightRed
            statusLabel.textColor = .Pino.red
            statusLabel.text = activityCellVM.failedStatusText
			statusLabel.isHidden = false
            statusLabelContainer.isHidden = false
		case .pending:
            statusLabelContainer.backgroundColor = .Pino.lightOrange
            statusLabel.textColor = .Pino.pendingOrange
            statusLabel.text = activityCellVM.pendingStatusText
			statusLabel.isHidden = false
            statusLabelContainer.isHidden = false
		case .success:
            statusLabelContainer.isHidden = true
			statusLabel.isHidden = true
		}

		historyCardView.layer.cornerRadius = 12
	}

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		historyIcon.layer.cornerRadius = historyIcon.frame.height * 0.5
		statusLabelContainer.layer.cornerRadius = 10
        statusLabelContainer.layer.masksToBounds = true
	}

	private func setupConstraint() {
		historyCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		contentStackView.pin(
			.centerY,
			.leading(padding: 14)
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
}

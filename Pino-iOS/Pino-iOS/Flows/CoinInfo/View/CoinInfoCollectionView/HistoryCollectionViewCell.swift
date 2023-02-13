//
//  HistoryCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/18/23.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
	// MARK: - private Properties

	private var activiityCardView = UIView()
	private var contentStackView = UIStackView()
	private var activityIcon = UIImageView()
	private var activityTitleStackView = UIStackView()
	private var activityTitleLabel = PinoLabel(style: .title, text: nil)
	private var statusStackView = UIStackView()
	private var timeLabel = UILabel()
	private var statusLabel = UILabel()
	private var statusIcon = UIImageView()

	// MARK: - public properties

	public static let cellID = "historyCell"

	public var historyCoinInfoVM: ActivityHistoryViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			layoutIfNeeded()
		}
	}

	// MARK: - private UI method

	private func setupView() {
		contentView.addSubview(activiityCardView)
		activiityCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(activityIcon)
		contentStackView.addArrangedSubview(activityTitleStackView)
		activityTitleStackView.addArrangedSubview(activityTitleLabel)
		activityTitleStackView.addArrangedSubview(statusStackView)
		statusStackView.addArrangedSubview(timeLabel)
		statusStackView.addArrangedSubview(statusLabel)
		statusStackView.addArrangedSubview(statusIcon)
	}

	private func setupStyle() {
		activityIcon.image = UIImage(named: historyCoinInfoVM.activityIcon)
		activityTitleLabel.text = historyCoinInfoVM.activityTitle
		timeLabel.text = historyCoinInfoVM.time

		backgroundColor = .Pino.background

		activiityCardView.layer.cornerRadius = 12
		activiityCardView.backgroundColor = .Pino.secondaryBackground
		activityIcon.backgroundColor = .Pino.background

		contentStackView.axis = .horizontal
		activityTitleStackView.axis = .vertical
		statusStackView.axis = .horizontal
		statusStackView.distribution = .fill

		contentStackView.spacing = 12
		activityTitleStackView.spacing = 8
		statusStackView.spacing = 4

		activityTitleStackView.alignment = .leading

		activityIcon.backgroundColor = .Pino.background
		activityIcon.contentMode = .center

		activityTitleLabel.font = .PinoStyle.mediumCallout
		timeLabel.font = .PinoStyle.mediumFootnote
		statusLabel.font = .PinoStyle.mediumFootnote

		activityTitleLabel.textColor = .Pino.label
		statusLabel.backgroundColor = .Pino.lightOrange
		statusLabel.textColor = .Pino.pendingOrange
		timeLabel.textColor = .Pino.secondaryLabel

		statusLabel.text = "Pending..."

		statusLabel.textAlignment = .center
		statusIcon.image = UIImage(named: "Info-Circle, error")
		statusIcon.tintColor = .Pino.red

		switch historyCoinInfoVM.status {
		case .failed:
			statusIcon.isHidden = false
			statusLabel.isHidden = true
		case .pending:
			statusIcon.isHidden = true
			statusLabel.isHidden = false
		case .success:
			statusIcon.isHidden = true
			statusLabel.isHidden = true
		}
	}

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		activityIcon.layer.cornerRadius = activityIcon.frame.height * 0.5
		statusLabel.layer.cornerRadius = 10
		statusLabel.layer.masksToBounds = true
	}

	private func setupConstraint() {
		activiityCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		contentStackView.pin(.centerY, .leading(padding: 14))
		activityIcon.pin(.fixedWidth(44), .fixedHeight(44))
		statusLabel.pin(.fixedHeight(20), .fixedWidth(80))
	}
}

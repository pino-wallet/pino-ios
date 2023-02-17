//
//  CoinHistoryCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import UIKit

class CoinHistoryCell: UICollectionViewCell {
	// MARK: - private Properties

	private var historyCardView = UIView()
	private var contentStackView = UIStackView()
	private var historyIcon = UIImageView()
	private var historyTitleStackView = UIStackView()
	private var historyTitleLabel = PinoLabel(style: .title, text: nil)
	private var historyTimeLabel = UILabel()
	private var statusStackView = UIStackView()
	private var statusLabel = UILabel()
	private var statusIcon = UIImageView()

	// MARK: - public properties

	public static let cellID = "coinHistoryCell"

	public var coinHistoryVM: CoinHistoryViewModel! {
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
		historyCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(historyIcon)
		contentStackView.addArrangedSubview(historyTitleStackView)
		historyTitleStackView.addArrangedSubview(historyTitleLabel)
		historyTitleStackView.addArrangedSubview(statusStackView)
		statusStackView.addArrangedSubview(historyTimeLabel)
		statusStackView.addArrangedSubview(statusLabel)
		statusStackView.addArrangedSubview(statusIcon)
	}

	private func setupStyle() {
		historyIcon.image = UIImage(named: coinHistoryVM.activityIcon)
		historyTitleLabel.text = coinHistoryVM.activityTitle
		historyTimeLabel.text = coinHistoryVM.time

		backgroundColor = .Pino.background

		historyCardView.layer.cornerRadius = 12
		historyCardView.backgroundColor = .Pino.secondaryBackground
		historyIcon.backgroundColor = .Pino.background

		contentStackView.axis = .horizontal
		historyTitleStackView.axis = .vertical
		statusStackView.axis = .horizontal
		statusStackView.distribution = .fill

		contentStackView.spacing = 12
		historyTitleStackView.spacing = 8
		statusStackView.spacing = 4

		historyTitleStackView.alignment = .leading

		historyIcon.backgroundColor = .Pino.background
		historyIcon.contentMode = .center

		historyTitleLabel.font = .PinoStyle.mediumCallout
		historyTimeLabel.font = .PinoStyle.mediumFootnote
		statusLabel.font = .PinoStyle.mediumFootnote

		historyTitleLabel.textColor = .Pino.label
		statusLabel.backgroundColor = .Pino.lightOrange
		statusLabel.textColor = .Pino.pendingOrange
		historyTimeLabel.textColor = .Pino.secondaryLabel

		statusLabel.text = "Pending..."

		statusLabel.textAlignment = .center
		statusIcon.image = UIImage(named: "Info-Circle, error")
		statusIcon.tintColor = .Pino.red

		switch coinHistoryVM.status {
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
		historyIcon.layer.cornerRadius = historyIcon.frame.height * 0.5
		statusLabel.layer.cornerRadius = 10
		statusLabel.layer.masksToBounds = true
	}

	private func setupConstraint() {
		historyCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		contentStackView.pin(.centerY, .leading(padding: 14))
		historyIcon.pin(.fixedWidth(44), .fixedHeight(44))
		statusLabel.pin(.fixedHeight(20), .fixedWidth(80))
	}
}

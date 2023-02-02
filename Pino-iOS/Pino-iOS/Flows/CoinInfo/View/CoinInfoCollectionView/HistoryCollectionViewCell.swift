//
//  HistoryCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/18/23.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
	// MARK: - private Properties

	private var actionCardView = UIView()
	private var contentStackView = UIStackView()
	private var actionIcon = UIImageView()
	private var actionTitleStackView = UIStackView()
	private var actionTitleLabel = UILabel()
	private var statusStackView = UIStackView()
	private var timeLabel = UILabel()
	private var statusLabel = UILabel()
	private var statusIcon = UIImageView()

	// MARK: - public properties

	public static let cellID = "historyCell"

	public var historyCoinInfoVM: ActionHistoryViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			layoutIfNeeded()
		}
	}

	// MARK: - private UI method

	private func setupView() {
		contentView.addSubview(actionCardView)
		actionCardView.addSubview(contentStackView)
		contentStackView.addArrangedSubview(actionIcon)
		contentStackView.addArrangedSubview(actionTitleStackView)
		actionTitleStackView.addArrangedSubview(actionTitleLabel)
		actionTitleStackView.addArrangedSubview(statusStackView)
		statusStackView.addArrangedSubview(timeLabel)
		statusStackView.addArrangedSubview(statusLabel)
		statusStackView.addArrangedSubview(statusIcon)
	}

	private func setupStyle() {
		actionIcon.image = UIImage(named: historyCoinInfoVM.actionIcon)
		actionTitleLabel.text = historyCoinInfoVM.actionTitle
		timeLabel.text = historyCoinInfoVM.time

		switch historyCoinInfoVM.status {
		case .failed:
			statusIcon.alpha = 1
			statusLabel.alpha = 0
		case .pending:
			statusLabel.alpha = 1
			statusLabel.text = "Pending..."
		case .success:
			statusIcon.alpha = 0
			statusLabel.alpha = 0
		}

		backgroundColor = .Pino.background

		actionCardView.layer.cornerRadius = 12
		actionCardView.backgroundColor = .Pino.secondaryBackground
		actionIcon.backgroundColor = .Pino.background

		contentStackView.axis = .horizontal
		actionTitleStackView.axis = .vertical
		statusStackView.axis = .horizontal

		contentStackView.spacing = 12
		actionTitleStackView.spacing = 8
		statusStackView.spacing = 4

		actionIcon.backgroundColor = .Pino.background
		actionIcon.contentMode = .center

		actionTitleLabel.font = .PinoStyle.mediumFootnote
		timeLabel.font = .PinoStyle.mediumFootnote
		statusLabel.font = .PinoStyle.mediumFootnote

		statusLabel.backgroundColor = .Pino.lightOrange
		statusLabel.textColor = .Pino.pendingOrange
		timeLabel.textColor = .Pino.black

		statusLabel.textAlignment = .center
	}

	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		actionIcon.layer.cornerRadius = actionIcon.frame.height * 0.5
		statusLabel.layer.cornerRadius = 10
		statusLabel.layer.masksToBounds = true
	}

	private func setupConstraint() {
		actionCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		contentStackView.pin(.centerY, .leading(padding: 14))
		actionIcon.pin(.fixedWidth(44), .fixedHeight(44))

		actionTitleStackView.pin(.trailing(padding: 14))

		statusLabel.pin(.fixedHeight(20), .fixedWidth(80))
	}
}

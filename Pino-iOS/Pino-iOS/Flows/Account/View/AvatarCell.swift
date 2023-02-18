//
//  AvatarCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/15/23.
//

import UIKit

public class AvatarCell: UICollectionViewCell {
	// MARK: Private Properties

	private let avatarIconBackgroundView = UIView()
	private let avatarIcon = UIImageView()
	private let checkMarkImageView = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "avatarCell"

	public var avatarName: String! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	public var style: Style = .regular {
		didSet {
			updateStyle()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(avatarIconBackgroundView)
		contentView.addSubview(checkMarkImageView)
		avatarIconBackgroundView.addSubview(avatarIcon)
	}

	private func setupStyle() {
		avatarIcon.image = UIImage(named: avatarName)
		checkMarkImageView.image = UIImage(named: "avatar_checkmark")
		avatarIconBackgroundView.backgroundColor = UIColor(named: avatarName)
		avatarIconBackgroundView.layer.cornerRadius = 35
		avatarIconBackgroundView.layer.borderColor = UIColor.Pino.green.cgColor
		updateStyle()
	}

	private func setupConstraint() {
		avatarIconBackgroundView.pin(
			.fixedWidth(70),
			.fixedHeight(70)
		)
		avatarIcon.pin(
			.allEdges(padding: 12)
		)
		checkMarkImageView.pin(
			.fixedHeight(20),
			.fixedWidth(20),
			.trailing,
			.bottom
		)
	}

	private func updateStyle() {
		switch style {
		case .regular:
			avatarIconBackgroundView.layer.borderWidth = 0
			checkMarkImageView.alpha = 0
		case .selected:
			UIView.animate(withDuration: 0.3) {
				self.avatarIconBackgroundView.layer.borderWidth = 2.2
				self.checkMarkImageView.alpha = 1
			}
		}
	}
}

extension AvatarCell {
	public enum Style {
		case regular
		case selected
	}
}

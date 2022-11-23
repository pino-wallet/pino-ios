//
//  SuggestedSeedPhraseCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//

import UIKit

public class SuggestedSeedPhraseCell: UICollectionViewCell {
	// MARK: Private Properties

	private let seedPhraseView = UIView()
	private let seedPhraseTitle = UILabel()

	// MARK: Public Properties

	public static let cellReuseID = "suggestSeedPhraseCell"
	public var suggestedWord: String! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(seedPhraseView)
		seedPhraseView.addSubview(seedPhraseTitle)
	}

	private func setupStyle() {
		seedPhraseView.backgroundColor = .Pino.background
		seedPhraseView.layer.cornerRadius = 8

		seedPhraseTitle.text = suggestedWord
		seedPhraseTitle.font = .PinoStyle.mediumCallout
		seedPhraseTitle.textColor = .Pino.label
	}

	private func setupConstraint() {
		seedPhraseView.pin(
			.allEdges
		)
		seedPhraseTitle.pin(
			.verticalEdges(padding: 8),
			.horizontalEdges(padding: 14)
		)
	}
}

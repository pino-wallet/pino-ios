//
//  SecretPhraseCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

public class SecretPhraseCell: UICollectionViewCell {
	// MARK: Private Properties

	private let seedPhraseView = UIView()
	private let seedPhraseStackView = UIStackView()
	private let seedPhraseTitle = UILabel()
	private let seedPhraseSequence = UILabel()
	private let dashedBorder = CAShapeLayer()

	// MARK: Public Properties

	public var seedPhrase: SeedPhrase! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			updateSeedPhrase(title: seedPhrase.title, sequence: seedPhrase.sequence)
		}
	}

	public var seedPhraseStyle: SeedPhraseStyle = .defaultStyle {
		didSet {
			switch seedPhraseStyle {
			case .defaultStyle:
				updateSeedPhrase(title: seedPhrase.title, sequence: seedPhrase.sequence)
			case .noSequence:
				updateSeedPhrase(title: seedPhrase.title, sequence: nil)
			case .empty:
				updateSeedPhrase(title: "", sequence: nil, isEmpty: true)
			}
		}
	}

	// MARK: Private Methods

	private func updateSeedPhrase(title: String, sequence: Int?, isEmpty: Bool = false) {
		seedPhraseTitle.text = title

		if let sequence = sequence {
			seedPhraseSequence.text = String(sequence)
		} else {
			seedPhraseSequence.text = ""
		}

		if isEmpty {
			dashedBorder.isHidden = false
			seedPhraseView.layer.borderWidth = 0
		} else {
			dashedBorder.isHidden = true
			seedPhraseView.layer.borderWidth = 1
		}
	}
}

extension SecretPhraseCell {
	// MARK: UI Methods

	private func setupView() {
		contentView.addSubview(seedPhraseView)
		seedPhraseView.addSubview(seedPhraseStackView)
		seedPhraseStackView.addArrangedSubview(seedPhraseSequence)
		seedPhraseStackView.addArrangedSubview(seedPhraseTitle)
	}

	private func setupStyle() {
		seedPhraseView.backgroundColor = .Pino.secondaryBackground
		seedPhraseView.layer.cornerRadius = 8
		seedPhraseView.layer.borderColor = UIColor.Pino.gray5.cgColor

		seedPhraseStackView.axis = .horizontal
		seedPhraseStackView.spacing = 2

		seedPhraseSequence.font = .PinoStyle.mediumCallout
		seedPhraseSequence.textColor = .Pino.gray2

		seedPhraseTitle.font = .PinoStyle.mediumCallout
		seedPhraseTitle.textColor = .Pino.label
	}

	private func setupConstraint() {
		seedPhraseView.pin(
			.allEdges
		)
		seedPhraseStackView.pin(
			.horizontalEdges(padding: 14),
            .verticalEdges(padding: 6)
		)
	}

	private func addDashedBorder(to view: UIView) {
		let frameSize = frame.size
		let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
		dashedBorder.bounds = shapeRect
		dashedBorder.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
		dashedBorder.fillColor = UIColor.Pino.clear.cgColor
		dashedBorder.strokeColor = UIColor.Pino.gray3.cgColor
		dashedBorder.lineWidth = 1
		dashedBorder.lineJoin = CAShapeLayerLineJoin.round
		dashedBorder.lineDashPattern = [4, 4]
		dashedBorder.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 8).cgPath
		view.layer.addSublayer(dashedBorder)
	}

	// MARK: UI Overrides

	override public func layoutSubviews() {
		addDashedBorder(to: seedPhraseView)
	}
}

extension SecretPhraseCell {
	// MARK: Custom Cell Styles

	public enum SeedPhraseStyle {
		case defaultStyle
		case noSequence
		case empty
	}
}

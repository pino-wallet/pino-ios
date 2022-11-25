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

	public static let reuseID = "secretPhraseCell"
	public var seedPhrase: SeedPhrase! {
		didSet {
			updateSeedphraseSequence(seedPhrase.sequence)
			updateSeedphraseTitle(seedPhrase.title)
			updateSeedphraseBorder(seedPhrase.style)
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func updateSeedphraseSequence(_ sequence: Int?) {
		if let sequence {
			seedPhraseSequence.isHidden = false
			seedPhraseSequence.text = String(sequence)
		} else {
			seedPhraseSequence.isHidden = true
		}
	}

	private func updateSeedphraseTitle(_ title: String?) {
		if let title {
			seedPhraseTitle.isHidden = false
			seedPhraseTitle.text = title
		} else {
			seedPhraseTitle.isHidden = true
		}
	}

	private func updateSeedphraseBorder(_ style: SecretPhraseCell.Style) {
		switch style {
		case .regular, .unordered:
			dashedBorder.lineDashPattern = [1, 0]
		case .empty:
			dashedBorder.lineDashPattern = [3, 3]
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
			.verticalEdges(padding: 8)
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
		dashedBorder.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 8).cgPath
		view.layer.addSublayer(dashedBorder)
	}

	// MARK: UI Overrides

	override public func layoutSubviews() {
		addDashedBorder(to: seedPhraseView)
	}
}

extension SecretPhraseCell {
	// MARK: Custom Styles

	public enum Style {
		case regular
		case unordered
		case empty
	}
}

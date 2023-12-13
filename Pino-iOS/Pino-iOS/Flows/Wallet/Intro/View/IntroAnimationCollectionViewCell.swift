//
//  IntroCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/20/22.
//

import Lottie
import UIKit

public class IntroAnimationCollectionViewCell: UICollectionViewCell {
	// MARK: Private Properties

	private let introAnimationView = LottieAnimationView()
	private let introTitle = PinoLabel(style: .title, text: "hi")
	private let introGradientView = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "introAnimationCell"
	public var introModel: IntroModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			setImageCornerRadius()
		}
	}
}

extension IntroAnimationCollectionViewCell {
	// MARK: UI Methods

	private func setupView() {
		contentView.addSubview(introAnimationView)
		contentView.addSubview(introTitle)
		contentView.insertSubview(introGradientView, belowSubview: introAnimationView)
	}

	private func setupStyle() {
		introTitle.text = introModel.title
		introTitle.numberOfLines = 2
		introTitle.textAlignment = .center

		introGradientView.image = UIImage(named: "intro-gradient")
		introGradientView.contentMode = .redraw

		introAnimationView.backgroundColor = .Pino.clear
		introAnimationView.animation = LottieAnimation.named("IntroAnimation")
		introAnimationView.play()
		introAnimationView.loopMode = .loop
	}

	private func setupConstraint() {
		introGradientView.pin(
			.allEdges
		)
		introAnimationView.pin(
			.horizontalEdges,
			.top
		)
		introTitle.pin(
			.horizontalEdges(padding: 16),
			.bottom,
			.relative(.top, -16, to: introAnimationView, .bottom),
			.fixedHeight(30)
		)
	}

	private func setImageCornerRadius() {
		layoutIfNeeded()
	}
}

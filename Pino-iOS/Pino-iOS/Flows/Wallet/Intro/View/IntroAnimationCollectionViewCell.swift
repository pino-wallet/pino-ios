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
	private let animationBtmCoverView = UIView()
	private var topGradientView = UIImageView()
	private var btmGradientView = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "introAnimationCell"

	var introTitleModel: String! {
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
		contentView.insertSubview(topGradientView, aboveSubview: introAnimationView)
		contentView.insertSubview(btmGradientView, aboveSubview: introAnimationView)
		contentView.addSubview(animationBtmCoverView)
	}

	private func setupStyle() {
		introTitle.text = introTitleModel
		introTitle.numberOfLines = 0
		introTitle.lineBreakMode = .byWordWrapping
		introTitle.textAlignment = .center
		introTitle.layer.zPosition = 1

		introGradientView.image = UIImage(named: "intro-gradient")
		introGradientView.contentMode = .redraw

		topGradientView.image = .init(named: "intro-top-grad")
		btmGradientView.image = .init(named: "intro-btm-grad")

		animationBtmCoverView.backgroundColor = .Pino.secondaryBackground
	}

	private func setupConstraint() {
		introTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
		introTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

		introGradientView.pin(
			.allEdges
		)
		introAnimationView.pin(
			.horizontalEdges,
			.top(padding: -100),
			.relative(.bottom, 40, to: btmGradientView, .bottom)
		)
		introTitle.pin(
			.bottom,
			.relative(.top, -106, to: introAnimationView, .bottom),
			.centerX
		)
		topGradientView.pin(
			.top(padding: -10),
			.horizontalEdges,
			.fixedHeight(150)
		)
		btmGradientView.pin(
			.bottom(padding: 30),
			.horizontalEdges,
			.fixedHeight(190)
		)

		animationBtmCoverView.pin(
			.horizontalEdges,
			.fixedHeight(40),
			.relative(.bottom, 0, to: introAnimationView, .bottom)
		)
	}

	private func setImageCornerRadius() {
		layoutIfNeeded()
	}

	// MARK: - Public Methods

	public func removeLottieFromRam() {
		introAnimationView.animation = nil
	}

	public func loadLottieAnimation() {
		if introAnimationView.animation == nil {
			introAnimationView.backgroundColor = .Pino.clear
			introAnimationView.animation = LottieAnimation.named("IntroAnimation")
			introAnimationView.play()
			introAnimationView.animationSpeed = 1
			introAnimationView.loopMode = .loop
		}
	}
}

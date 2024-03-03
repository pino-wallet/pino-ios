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
	}

	private func setupStyle() {
		introTitle.text = introTitleModel
		introTitle.numberOfLines = 0
        introTitle.lineBreakMode = .byWordWrapping
		introTitle.textAlignment = .center

		introGradientView.image = UIImage(named: "intro-gradient")
		introGradientView.contentMode = .redraw

		topGradientView.image = .init(named: "intro-top-grad")
		btmGradientView.image = .init(named: "intro-btm-grad")
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
			.bottom(padding: -70)
		)
		introTitle.pin(
			.bottom,
			.relative(.top, -130, to: introAnimationView, .bottom),
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
			.fixedHeight(150)
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
			//        introAnimationView.configuration.renderingEngine = .
			introAnimationView.play()
			introAnimationView.animationSpeed = 1
			introAnimationView.loopMode = .loop
		}
	}
}

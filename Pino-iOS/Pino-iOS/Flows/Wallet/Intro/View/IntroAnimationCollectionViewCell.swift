//
//  IntroCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/20/22.
//

import UIKit
import Lottie

public class IntroAnimationCollectionViewCell: UICollectionViewCell {
    // MARK: Private Properties
    
    private let contentStackView = UIStackView()
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
        contentView.addSubview(contentStackView)
        contentView.insertSubview(introGradientView, belowSubview: contentStackView)
        contentStackView.addArrangedSubview(introAnimationView)
        contentStackView.addArrangedSubview(introTitle)
    }
    
    private func setupStyle() {
        introTitle.text = introModel.title
        introTitle.numberOfLines = 2
        introGradientView.image = UIImage(named: "intro-gradient")
        introGradientView.contentMode = .redraw
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .center
        
        introAnimationView.backgroundColor = .Pino.clear
        
        introAnimationView.animation = LottieAnimation.named("IntroAnimation")
        introAnimationView.play()
        introAnimationView.loopMode = .loop
    }
    
    private func setupConstraint() {
        contentStackView.pin(
            .allEdges
        )
        introGradientView.pin(
            .allEdges
        )
        NSLayoutConstraint.activate([
            introAnimationView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            introTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setImageCornerRadius() {
        layoutIfNeeded()
    }
}

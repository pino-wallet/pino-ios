//
//  BlurEffectView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/16/22.
//

import UIKit

class BlurEffectView: UIVisualEffectView {
    
    // MARK: Private Properties
    
    private var animator = UIViewPropertyAnimator()
    
    // MARK: Initializers
    
    deinit{
        animator.stopAnimation(true)
    }
    
    // MARK: View Ovverides
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        backgroundColor = .clear
        frame = superview.bounds
        setupBlur()
    }
    
    // MARK: Private Methods

    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil
        
        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .extraLight)
        }
        animator.fractionComplete = 0.2 // Blur density
    }
}

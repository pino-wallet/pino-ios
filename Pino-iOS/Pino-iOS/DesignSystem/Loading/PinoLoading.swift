//
//  PinoLoading.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/12/23.
//

import UIKit

class PinoLoading: UIView {
    // MARK: - Public Properties
    
    public var size: CGFloat {
        didSet {
            setupContraints()
        }
    }
    
    public var loadingSpeed: SpeedType {
        didSet {
            loadingAnimator.stopAnimation(true)
            startLoadingAnimation(duration: loadingSpeed.rawValue)
        }
    }
    
    public var imageType: ImageType {
        didSet {
            loadingImageView.image = UIImage(named: imageType.rawValue)
        }
    }
    
    // MARK: - Private Properties
    
    private let loadingImageView = UIImageView()
    private var loadingAnimator: UIViewPropertyAnimator!
    
    // MARK: - Initializers
    
    init(size: CGFloat, imageType: ImageType = .primary, loadingSpeed: SpeedType = .normal) {
        self.size = size
        self.imageType = imageType
        self.loadingSpeed = loadingSpeed
        super.init(frame: .zero)
        setupView()
        setupStyles()
        setupContraints()
        startLoadingAnimation(duration: loadingSpeed.rawValue)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addSubview(loadingImageView)
    }
    
    private func setupStyles() {
        loadingImageView.image = UIImage(named: imageType.rawValue)
    }
    
    private func startLoadingAnimation(duration: Double) {
        loadingAnimator =  UIViewPropertyAnimator(duration: duration, curve: .linear, animations: { [weak self] in
            guard let self else {
                return
            }
              self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: .pi)
          })
        loadingAnimator.addCompletion { [weak self] _ in
            self?.startLoadingAnimation(duration: duration)
        }
        loadingAnimator.startAnimation()
    }

	private func setupContraints() {
		loadingImageView.pin(.allEdges(padding: 0), .fixedWidth(size), .fixedHeight(size))
		layoutIfNeeded()
	}
}

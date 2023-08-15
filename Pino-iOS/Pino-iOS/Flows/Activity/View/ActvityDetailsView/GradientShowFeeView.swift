//
//  GradientShowFeeView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/13/23.
//

import UIKit

class GradientShowFeeView: GradientBorderView {
    // MARK: - Public Properties
    public var titleText: String {
        didSet {
            titleLabel.text = titleText
        }
    }
    // MARK: - Private Properties
    private let mainStackView = UIStackView()
    private let titleLabel = PinoLabel(style: .title, text: "")
    private let descriptionLabel = PinoLabel(style: .description, text: "")
    private var descriptionText: String
    
    // MARK: - Initializers
    init(titleText: String, descriptionText: String) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        
        super.init(frame: .zero)
        
        setupView()
        setupStyles()
        setupConstraints()
        setupSkeletonViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        
        addSubview(mainStackView)
    }
    
    private func setupStyles() {
        layer.cornerRadius = 12
        layer.masksToBounds = true

        frame = bounds
        
        backgroundColor = .Pino.clear
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.alignment = .leading
        
        descriptionLabel.font = .PinoStyle.mediumFootnote
        
        titleLabel.text = titleText
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = descriptionText
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        
        mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 12))
    }
    
    private func setupSkeletonViews() {
        titleLabel.isSkeletonable = true
    }
}

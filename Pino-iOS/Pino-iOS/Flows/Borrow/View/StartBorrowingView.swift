//
//  StartCollateralView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//

import UIKit

class StartBorrowingView: UIView {
    // MARK: - Closures
    public var didTapActionButtonClosure: () -> Void
    // MARK: - Private Properties
    private let containerView = PinoContainerCard()
    private let mainStackView = UIStackView()
    private let titleLabel = PinoLabel(style: .title, text: "")
    private let descriptionLabel = PinoLabel(style: .description, text: "")
    private let actionButton = UIButton()
    private var titleText: String
    private var descriptionText: String
    private var buttonTitleText: String
    
    // MARK: - Initializers
    
    init(titleText: String, descriptionText: String, buttonTitleText: String, didTapActionButtonClosure: @escaping () -> Void) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.buttonTitleText = buttonTitleText
        self.didTapActionButtonClosure = didTapActionButtonClosure
        
        super.init(frame: .zero)
        
        setupView()
        setupStyles()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(actionButton)
        
        containerView.addSubview(mainStackView)
       addSubview(containerView)
    }
    
    private func setupStyles() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        mainStackView.alignment = .leading
        mainStackView.setCustomSpacing(18, after: descriptionLabel)
        
        titleLabel.text = titleText
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = descriptionText
        descriptionLabel.numberOfLines = 0
        
        actionButton.addTarget(self, action: #selector(didTapactionbutton), for: .touchUpInside)
        
        var actionButtonConfigurations = PinoButton.Configuration.filled()
        let actionButtonImage = UIImage(named: "primary_right_arrow")?.withTintColor(.Pino.secondaryBackground)
        actionButtonConfigurations.image = actionButtonImage
        actionButtonConfigurations.imagePadding = 4
        actionButtonConfigurations.imagePlacement = .trailing
        actionButtonConfigurations.background.backgroundColor = .Pino.primary
        var attributedTitle = AttributedString(buttonTitleText)
        attributedTitle.font = .PinoStyle.semiboldCallout
        attributedTitle.foregroundColor = .Pino.secondaryBackground
        actionButtonConfigurations.attributedTitle = attributedTitle
        actionButton.configuration = actionButtonConfigurations
    }
    
    private func setupConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
        actionButton.pin(.fixedHeight(40))
        
        containerView.pin(.allEdges(padding: 0))
        mainStackView.pin(.horizontalEdges(padding: 10), .verticalEdges(padding: 16))
    }
    
    @objc private func didTapactionbutton() {
        didTapActionButtonClosure()
    }
}

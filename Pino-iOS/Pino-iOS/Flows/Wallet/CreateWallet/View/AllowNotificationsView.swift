//
//  AllowNotificationsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/15/23.
//

import UIKit

class AllowNotificationsView: UIView {
    // MARK: - Closures
    
        public let dismissPage: () -> Void
    
    // MARK: - Public Properties
    
    public let allowNotificationsVM: AllowNotificationsViewModel
    
    // MARK: - Initializers
    
    init(allowNotificationsVM: AllowNotificationsViewModel, dismissPage: @escaping () -> Void) {
        self.allowNotificationsVM = allowNotificationsVM
        self.dismissPage = dismissPage
        super.init(frame: .zero)
        
        setupView()
        setupStyles()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private let headerStackView = UIStackView()
    private let headerIconContainerView = UIView()
    private let headerIconView = UIImageView()
    private let headerTitleLabelContainerView = UIView()
    private let headerTitleLabel = PinoLabel(style: .title, text: "")
    private let headerDescriptionLabelContainerView = UIView()
    private let headerDescriptionLabel = PinoLabel(style: .info, text: "")
    private let sampleNotificationsContainerView = UIView()
    private let sampleNotificationCard1 = UIImageView()
    private let sampleNotificationCard2 = UIImageView()
    private let sampleNotificationGradientContainer = UIView()
    private let buttonsStackView = UIStackView()
    private let enableNotificationsButton = PinoButton(style: .active, title: "")
    private let skipButton = PinoButton(style: .white, title: "")
    private let animationTime = 0.8
    private var paddingFromButtom: CGFloat!
    private var sampleNotificationGradientLayer: GradientLayer!
    
    // MARK: - Private Methods
    private func setupView() {
        headerIconContainerView.addSubview(headerIconView)
        
        headerTitleLabelContainerView.addSubview(headerTitleLabel)
        
        headerDescriptionLabelContainerView.addSubview(headerDescriptionLabel)
        
        enableNotificationsButton.addTarget(self, action: #selector(enableNotififcations), for: .touchUpInside)

        skipButton.addTarget(self, action: #selector(onSkip), for: .touchUpInside)
        
        headerStackView.addArrangedSubview(headerIconContainerView)
        headerStackView.addArrangedSubview(headerTitleLabelContainerView)
        headerStackView.addArrangedSubview(headerDescriptionLabelContainerView)
        
        buttonsStackView.addArrangedSubview(enableNotificationsButton)
        buttonsStackView.addArrangedSubview(skipButton)
        
        
        sampleNotificationsContainerView.addSubview(sampleNotificationCard1)
        sampleNotificationsContainerView.addSubview(sampleNotificationCard2)
        sampleNotificationsContainerView.addSubview(sampleNotificationGradientContainer)
        
        addSubview(headerStackView)
        addSubview(sampleNotificationsContainerView)
        
        addSubview(buttonsStackView)
    }
    
    private func setupStyles() {
        backgroundColor = .Pino.white
        
        headerStackView.axis = .vertical
        headerStackView.spacing = 8
        headerStackView.alignment = .center
        
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 24
        buttonsStackView.backgroundColor = .Pino.white
        
        sampleNotificationCard1.image = UIImage(named: allowNotificationsVM.sampleNotificationCardImage1)
        sampleNotificationCard1.isHidden = true
        
        sampleNotificationCard2.image = UIImage(named: allowNotificationsVM.sampleNotificationCardImage2)
        sampleNotificationCard2.isHidden = true
        
        enableNotificationsButton.title = allowNotificationsVM.enableNotificationsButtonTitleText
        
        skipButton.title = allowNotificationsVM.skipButtonTitleText
        
        headerIconView.image = UIImage(named: allowNotificationsVM.headerIcon)
        
        headerTitleLabel.text = allowNotificationsVM.titleText
        headerTitleLabel.numberOfLines = 0
        headerTitleLabel.textAlignment = .center
        headerDescriptionLabel.lineBreakMode = .byWordWrapping
        headerTitleLabel.font = .PinoStyle.semiboldTitle2
        
        headerDescriptionLabel.text = allowNotificationsVM.descriptionText
        headerDescriptionLabel.numberOfLines = 0
        headerDescriptionLabel.textAlignment = .center
        headerDescriptionLabel.lineBreakMode = .byWordWrapping
        headerDescriptionLabel.textColor = .Pino.secondaryLabel
        
        let safeAreaExists = (window?.safeAreaInsets.bottom != 0)
        paddingFromButtom = safeAreaExists ? 12 : 32
    }
    
    private func setupConstraints() {
        sampleNotificationCard1.translatesAutoresizingMaskIntoConstraints = false
        sampleNotificationCard2.translatesAutoresizingMaskIntoConstraints = false
        let sampleNotificationCard1Constraint = NSLayoutConstraint(
            item: sampleNotificationCard1,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: buttonsStackView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        let sampleNotificationCard2Constraint = NSLayoutConstraint(
            item: sampleNotificationCard2,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: buttonsStackView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        sampleNotificationCard1Constraint.priority = UILayoutPriority(249)
        sampleNotificationCard2Constraint.priority = UILayoutPriority(249)
        NSLayoutConstraint.activate([
            sampleNotificationCard1Constraint,
            sampleNotificationCard2Constraint,
        ])
        
        headerIconView.pin(.fixedWidth(56), .fixedHeight(56))
        headerStackView.pin(.top(to: layoutMarginsGuide, padding: 8), .horizontalEdges(padding: 16))
        headerTitleLabel.pin(.horizontalEdges(padding: 0), .top(padding: 10), .bottom(padding: 0))
        headerIconView.pin(.allEdges(padding: 0))
        headerDescriptionLabel.pin(.verticalEdges(padding: 0), .horizontalEdges(padding: 16))
        sampleNotificationsContainerView.pin(
            .relative(.top, 0, to: headerStackView, .bottom),
            .horizontalEdges(padding: 16),
            .bottom(to: layoutMarginsGuide, padding: 0)
        )
        sampleNotificationGradientContainer.pin(
            .relative(.bottom, 0, to: buttonsStackView, .top),
            .horizontalEdges(padding: 0),
            .top(padding: 200)
        )
        sampleNotificationCard1.pin(.horizontalEdges(padding: 0))
        sampleNotificationCard2.pin(.horizontalEdges(padding: 0))
        buttonsStackView.pin(.horizontalEdges(padding: 16), .bottom(to: layoutMarginsGuide, padding: paddingFromButtom))
    }
    
    @objc
        private func onSkip() {
            dismissPage()
        }

        @objc
        private func enableNotififcations() {
            allowNotificationsVM.enableNotifications()
            dismissPage()
        }
    
    // MARK: - Public Methods
    
    public func animateSmapleNotificationsCard() {
        sampleNotificationCard1.isHidden = false
        sampleNotificationCard2.isHidden = false
        UIView.animate(
            withDuration: animationTime,
            delay: 0,
            usingSpringWithDamping: animationTime,
            initialSpringVelocity: animationTime,
            options: .curveEaseIn,
            animations: { [weak self] in
                let sampleNotificationCard1Constraint = NSLayoutConstraint(
                    item: self?.sampleNotificationCard1 as Any,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: self?.sampleNotificationsContainerView,
                    attribute: .top,
                    multiplier: 1,
                    constant: 24
                )
                sampleNotificationCard1Constraint.priority = UILayoutPriority(999)
                NSLayoutConstraint.activate([sampleNotificationCard1Constraint])
                self?.layoutIfNeeded()
            }
        ) { [weak self] _ in
            UIView.animate(
                withDuration: self!.animationTime,
                delay: 0,
                usingSpringWithDamping: self!.animationTime,
                initialSpringVelocity: self!.animationTime,
                options: .curveEaseIn,
                animations: { [weak self] in
                    let sampleNotificationCard2Constraint = NSLayoutConstraint(
                        item: self?.sampleNotificationCard2 as Any,
                        attribute: .top,
                        relatedBy: .equal,
                        toItem: self?.sampleNotificationsContainerView,
                        attribute: .top,
                        multiplier: 1,
                        constant: 148
                    )
                    sampleNotificationCard2Constraint.priority = UILayoutPriority(999)
                    NSLayoutConstraint.activate([sampleNotificationCard2Constraint])
                    self?.layoutIfNeeded()
                }
            )
        }
    }
    
    public func setupGradientStyle() {
        sampleNotificationGradientLayer = GradientLayer(
            frame: sampleNotificationGradientContainer.bounds,
            style: .notificationSample
        )
        sampleNotificationGradientContainer.layer.addSublayer(sampleNotificationGradientLayer)
    }
}

extension PinoButton.Style {
    fileprivate static let white = PinoButton.Style(
        titleColor: .Pino.primary,
        backgroundColor: .Pino.white,
        borderColor: .clear
    )
}

extension GradientLayer.Style {
    fileprivate static let notificationSample = GradientLayer.Style(
        colors: [UIColor.Pino.clear.cgColor, UIColor.Pino.white.cgColor],
        locations: [0, 0.4]
    )
}

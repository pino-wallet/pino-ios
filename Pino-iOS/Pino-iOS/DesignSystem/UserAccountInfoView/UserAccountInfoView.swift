//
//  UserAccountInfoView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/23/24.
//

import UIKit

class UserAccountInfoView: UIStackView {
    // MARK: - Public Properties
    
    public var userAccountInfoVM: UserAccountInfoViewModel? {
        didSet {
            setupStyles()
        }
    }

            


    // MARK: - Private Properties

    private let imageBackgroundView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = PinoLabel(style: .title, text: "")
    private let addressLabel = PinoLabel(style: .title, text: "")

    // MARK: - Initializers

    init(userAccountInfoVM: UserAccountInfoViewModel?) {
        self.userAccountInfoVM = userAccountInfoVM

        super.init(frame: .zero)

        setupView()
        setupStyles()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupView() {
        imageBackgroundView.addSubview(imageView)
        
        addArrangedSubview(imageBackgroundView)
        addArrangedSubview(nameLabel)
        addArrangedSubview(addressLabel)
    }

    private func setupStyles() {
        axis = .horizontal
        spacing = 2
        alignment = .center
        
        addressLabel.font = .PinoStyle.regularBody
        if let userAddress = userAccountInfoVM?.accountAddress {
            addressLabel.text = "(\(userAddress.addressFormating()))"
        }
        
        imageBackgroundView.layer.cornerRadius = 10
        imageBackgroundView.backgroundColor = UIColor(named: userAccountInfoVM?.accountIconColorName ?? "")

        nameLabel.font = .PinoStyle.mediumBody
        nameLabel.text = userAccountInfoVM?.accountName
        nameLabel.numberOfLines = 0

        imageView.image = UIImage(named: userAccountInfoVM?.accountIconName ?? "")
    }

    private func setupConstraints() {
        nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true

        imageBackgroundView.pin(.fixedWidth(20), .fixedHeight(20))
        imageView.pin(.fixedWidth(16), .fixedHeight(16), .centerX, .centerY)
    }
}


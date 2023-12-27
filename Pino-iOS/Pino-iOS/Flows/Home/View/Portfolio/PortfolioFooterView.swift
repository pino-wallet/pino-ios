//
//  PortfolioFooterView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/27/23.
//

import Foundation
import UIKit

class PortfolioFooterView: UICollectionReusableView {
    // MARK: - Private Properties
    private let mainStackView = UIStackView()
    private let textStackView = UIStackView()
    private let titleLabel = PinoLabel(style: .title, text: "")
    private let descriptionLabel = PinoLabel(style: .description, text: "")
    private let titleImageView = UIImageView()
    
    // MARK: - Public Properties
    public static let footerReuseID = "portfolioPerformanceFooter"
    
    
    public var footerVM: PortfolioFooterViewModel! {
        didSet {
            setupView()
            setupStyles()
            setupConstraints()
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(titleImageView)
        mainStackView.addArrangedSubview(textStackView)
        
        addSubview(mainStackView)
    }
    
    private func setupStyles() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.alignment = .center
        
        textStackView.axis = .vertical
        textStackView.spacing = 8
        textStackView.alignment = .center
        
        titleLabel.font = .PinoStyle.semiboldTitle2
        titleLabel.text = footerVM.titleText
        
        descriptionLabel.font = .PinoStyle.mediumBody
        descriptionLabel.text = footerVM.descriptionText
        
        titleImageView.image = UIImage(named: footerVM.titleImageName)
    }
    
    private func setupConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
        mainStackView.pin(.bottom(padding: 0), .top(padding: 64), .horizontalEdges(padding: 16))
    }
}

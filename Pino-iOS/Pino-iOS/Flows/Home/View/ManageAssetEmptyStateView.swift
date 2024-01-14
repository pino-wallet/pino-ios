//
//  ManageAssetEmptyStateView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/14/24.
//

import Foundation
import UIKit


class ManageAssetEmptyStateView: UIView {
    // MARK: - Closures
    private var onImportButton: () -> Void
    // MARK: - Private Properties
    private let manageAssetEmptyStateVM = ManageAssetEmptyStateViewModel()
    private let mainStackView = UIStackView()
    private let titleImageView = UIImageView()
    private let titleLabel = PinoLabel(style: .title, text: "")
    private let textStackView = UIStackView()
    private let descriptionStackView = UIStackView()
    private let descriptionLabel = PinoLabel(style: .description, text: "")
    private let importLabel = UILabel()
    
    // MARK: - Initializers
    init(onImportButton: @escaping () -> Void) {
        self.onImportButton = onImportButton
        
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
        let onImportTapGesture = UITapGestureRecognizer(target: self, action: #selector(onImportTap))
        importLabel.addGestureRecognizer(onImportTapGesture)
        importLabel.isUserInteractionEnabled = true
        
        mainStackView.addArrangedSubview(titleImageView)
        mainStackView.addArrangedSubview(textStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionStackView)
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(importLabel)
        
        addSubview(mainStackView)
    }
    
    private func setupStyles() {
        backgroundColor = .Pino.background
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.alignment = .center
        
        textStackView.axis = .vertical
        textStackView.spacing = 8
        textStackView.alignment = .center
        
        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = 2
        descriptionStackView.alignment = .center
        
        titleImageView.image = UIImage(named: manageAssetEmptyStateVM.titleImageName)
        
        titleLabel.font = .PinoStyle.semiboldTitle2
        titleLabel.text = manageAssetEmptyStateVM.titleText
        
        descriptionLabel.font = .PinoStyle.mediumBody
        descriptionLabel.text = manageAssetEmptyStateVM.descriptionText
        
        importLabel.textColor = .Pino.primary
        importLabel.font = .PinoStyle.boldBody
        importLabel.text = manageAssetEmptyStateVM.importButtonTitle
    }
    
    private func setupConstraints() {
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        descriptionStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
        mainStackView.pin(.horizontalEdges(padding: 16), .centerY)
        titleImageView.pin(.fixedWidth(56), .fixedHeight(56))
    }
    
    @objc private func onImportTap() {
       onImportButton()
    }
}

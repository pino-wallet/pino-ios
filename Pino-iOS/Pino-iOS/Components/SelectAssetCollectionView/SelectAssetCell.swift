//
//  SelectAssetCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import UIKit
import Kingfisher

class SelectAssetCell: UICollectionViewCell {
    // MARK: - Public Properties
    public var selectAssetCellVM: SelectAssetCellViewModel! {
        didSet {
            setupView()
            setupStyles()
            setupConstraints()
        }
    }
    
    public static let cellReuseID = "selectAssetCell"
    
    // MARK: - Private Properties
    private let mainContainerView = PinoContainerCard()
    private let mainStackView = UIStackView()
    private let assetImageView = UIImageView()
    private let assetInfoContainerView = UIView()
    private let assetInfoStackView = UIStackView()
    private let assetNameLabel = PinoLabel(style: .title, text: "")
    private let assetAmountAndSymbolLabel = PinoLabel(style: .description, text: "")
    
    // MARK: - Private Methods
    private func setupView() {
        assetInfoStackView.addArrangedSubview(assetNameLabel)
        assetInfoStackView.addArrangedSubview(assetAmountAndSymbolLabel)

        mainContainerView.addSubview(mainStackView)
        
        assetInfoContainerView.addSubview(assetInfoStackView)
        
        mainStackView.addArrangedSubview(assetImageView)
        mainStackView.addArrangedSubview(assetInfoContainerView)
        
        
        addSubview(mainContainerView)
    }
    
    private func setupStyles() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        
        assetInfoStackView.axis = .vertical
        assetInfoStackView.spacing = 4
        
        assetNameLabel.font = .PinoStyle.mediumCallout
        assetNameLabel.text = selectAssetCellVM.assetName
        assetNameLabel.numberOfLines = 0
        
        assetAmountAndSymbolLabel.font = .PinoStyle.mediumFootnote
        assetAmountAndSymbolLabel.text = "\(selectAssetCellVM.assetAmount) \(selectAssetCellVM.assetSymbol)"
        assetAmountAndSymbolLabel.numberOfLines = 0
        
        assetImageView.kf.indicatorType = .activity
        assetImageView.kf.setImage(with: selectAssetCellVM.assetLogo)
        assetImageView.backgroundColor = .Pino.background
        assetImageView.layer.cornerRadius = 22
    }
    
    private func setupConstraints() {
        assetNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        assetNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 220).isActive = true
        assetAmountAndSymbolLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        assetAmountAndSymbolLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 220).isActive = true
        mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 46).isActive = true
        
        mainContainerView.pin(.allEdges(padding: 0))
        mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 9))
        assetInfoStackView.pin(.leading(padding: 0), .verticalEdges(padding: 0))
        assetImageView.pin(.fixedHeight(44), .fixedWidth(44))
    }
    
}

//
//  SwapProtocolCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import UIKit

class DexProtocolCell: UICollectionViewCell {
    // MARK: - Public Properties

    public var dexProtocolVM: SelectDexProtocolCellVMProtocol! {
        didSet {
            setupView()
            setupStyles()
            setupConstraints()
        }
    }

    public static let cellReuseID = "swapProtocolCell"

    // MARK: - Private Properties

    private let mainContainerView = PinoContainerCard()
    private let mainStackView = UIStackView()
    private let swapProtocolImageView = UIImageView()
    private let swapProtocolTitleStackView = UIStackView()
    private let swapProtocolNameLabel = PinoLabel(style: .title, text: "")
    private let swapProtocolDescriptionLabel = PinoLabel(style: .description, text: "")

    // MARK: - Private Methods

    private func setupView() {
        addSubview(mainContainerView)
        mainContainerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(swapProtocolImageView)
        mainStackView.addArrangedSubview(swapProtocolTitleStackView)
        swapProtocolTitleStackView.addArrangedSubview(swapProtocolNameLabel)
        swapProtocolTitleStackView.addArrangedSubview(swapProtocolDescriptionLabel)
    }

    private func setupStyles() {
        swapProtocolNameLabel.text = dexProtocolVM.name
        swapProtocolDescriptionLabel.text = dexProtocolVM.description

        swapProtocolImageView.image = UIImage(named: dexProtocolVM.image)

        swapProtocolNameLabel.font = .PinoStyle.mediumCallout
        swapProtocolDescriptionLabel.font = .PinoStyle.mediumFootnote

        swapProtocolNameLabel.numberOfLines = 0
        swapProtocolDescriptionLabel.numberOfLines = 0

        swapProtocolImageView.backgroundColor = .Pino.background
        swapProtocolImageView.layer.cornerRadius = 22

        swapProtocolTitleStackView.axis = .vertical

        mainStackView.spacing = 8
        swapProtocolTitleStackView.spacing = 10

        mainStackView.alignment = .center
    }

    private func setupConstraints() {
        mainContainerView.pin(
            .allEdges
        )
        mainStackView.pin(
            .leading(padding: 14),
            .verticalEdges(padding: 10)
        )
        swapProtocolImageView.pin(
            .fixedHeight(44),
            .fixedWidth(44)
        )
    }
}

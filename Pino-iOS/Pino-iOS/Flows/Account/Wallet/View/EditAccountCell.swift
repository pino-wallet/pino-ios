//
//  EditAccountCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//

import UIKit

class EditAccountCell: UICollectionViewCell {
	// MARK: - Typealiases

	typealias manageIndexType = (viewIndex: Int, viewsCount: Int)

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let topBorderView = UIView()
	private let titleLabel = PinoLabel(style: .info, text: "")
	private let betWeenView = UIView()
	private let titleLabelContainverView = UIView()
	private let infoStackView = UIStackView()
	private let infoStackViewContainerView = UIView()
	private let describtionLabel = PinoLabel(style: .description, text: "")
	private let describtionLabelContainerView = UIView()
	private let rightIconImageView = UIImageView()

	// MARK: - Public Properties

	public var editAccountOptionVM: EditAccountOptionViewModel! {
		didSet {
			setupView()
			setupConstraints()
			setupStyle()
		}
	}

	public var manageIndex: manageIndexType! {
		didSet {
			manageViewUsingIndex(manageIndex: manageIndex)
		}
	}

	public var cellDescribtionText: String! {
		didSet {
			describtionLabel.text = cellDescribtionText
			describtionLabel.font = .PinoStyle.mediumBody
			describtionLabel.textColor = .Pino.gray2
			describtionLabel.numberOfLines = 0
			describtionLabel.lineBreakMode = .byWordWrapping
		}
	}

	public static let cellReuseID = "editAccountCellReuseID"

	// MARK: - Private Methods

	private func setupView() {
		titleLabelContainverView.addSubview(titleLabel)

		describtionLabelContainerView.addSubview(describtionLabel)

		infoStackView.addArrangedSubview(describtionLabelContainerView)
		infoStackView.addArrangedSubview(rightIconImageView)

		infoStackViewContainerView.addSubview(infoStackView)

		mainStackView.addArrangedSubview(titleLabelContainverView)
		mainStackView.addArrangedSubview(betWeenView)
		mainStackView.addArrangedSubview(infoStackViewContainerView)

		contentView.addSubview(mainStackView)
		contentView.addSubview(topBorderView)
	}

	private func setupConstraints() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabelContainverView.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
		describtionLabel.translatesAutoresizingMaskIntoConstraints = false
		describtionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120).isActive = true

		contentView.pin(.allEdges(padding: 0))
		titleLabel.pin(.allEdges(padding: 0))
		infoStackView.pin(.allEdges(padding: 0))
		describtionLabel.pin(.allEdges(padding: 0))
		mainStackView.pin(.verticalEdges(padding: 12), .horizontalEdges(padding: 16))
		topBorderView.pin(.fixedHeight(0.5), .top(padding: 0), .leading(padding: 16), .trailing(padding: 0))
		rightIconImageView.pin(.fixedWidth(24), .fixedHeight(24))
	}

	private func setupStyle() {
		contentView.layer.cornerRadius = 8
		contentView.layer.maskedCorners = []
		contentView.backgroundColor = .Pino.white

		topBorderView.backgroundColor = .Pino.gray3
		topBorderView.isHidden = true

		mainStackView.axis = .horizontal
		mainStackView.alignment = .center

		infoStackView.axis = .horizontal
		infoStackView.spacing = 2
		infoStackView.alignment = .center

		rightIconImageView.image = UIImage(named: editAccountOptionVM.rightIconName)

		titleLabel.text = editAccountOptionVM.title
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byWordWrapping
	}

	private func showTopBorder() {
		topBorderView.isHidden = false
	}

	private func setupTopCornerRadius() {
		contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}

	private func setupBottomCornerRadius() {
		contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
	}

	private func setupAllCornerRadiuses() {
		contentView.layer.maskedCorners = [
			.layerMaxXMinYCorner,
			.layerMinXMinYCorner,
			.layerMaxXMaxYCorner,
			.layerMinXMaxYCorner,
		]
	}

	private func manageViewUsingIndex(manageIndex: manageIndexType) {
		switch manageIndex.viewIndex {
		case let index where index == manageIndex.viewsCount - 1 && manageIndex.viewsCount > 1:
			showTopBorder()
			setupBottomCornerRadius()
		case let index where index == 0 && manageIndex.viewsCount == 1:
			setupAllCornerRadiuses()
		case let index where index == manageIndex.viewsCount - 1:
			setupBottomCornerRadius()
		case let index where index == 0:
			setupTopCornerRadius()
		case let index where index > 0:
			showTopBorder()
		default:
			break
		}
	}
}

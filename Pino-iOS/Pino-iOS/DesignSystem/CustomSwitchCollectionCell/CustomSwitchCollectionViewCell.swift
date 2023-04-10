//
//  SecurityLockCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class CustomSwitchCollectionViewCell: UICollectionViewCell {
	// MARK: - Typealiases

	typealias manageIndexType = (cellIndex: Int, cellsCount: Int)
	typealias switchValueClosureType = (_ isOn: Bool, _ type: String) -> Void
	typealias onTooltipTapClosureType = (_ tooltipTitle: String, _ tooltipText: String) -> Void

	// MARK: - Closures

	public var switchValueClosure: switchValueClosureType! = { isOn, type in }
	public var onTooltipTapClosure: onTooltipTapClosureType! = { tooltipTitle, tooltipText in }

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let topBorderView = UIView()
	private let titleLabel = PinoLabel(style: .info, text: "")
	private let switcher = UISwitch()
	private let tooltipImageView = UIButton()
	private let betWeenView = UIView()
	private let infoStackView = UIStackView()

	// MARK: - Public Properties

	public var customSwitchCollectionViewCellVM: CustomSwitchCollectionCellVM! {
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

	public static let cellReuseID = "CustomSwitchCollectionViewCell"

	// MARK: - Private Methods

	private func setupView() {
		contentView.addSubview(mainStackView)
		contentView.addSubview(topBorderView)

		switcher.isOn = customSwitchCollectionViewCellVM.isSelected
		switcher.addTarget(self, action: #selector(onSwitcherChange), for: .valueChanged)

		tooltipImageView.addTarget(self, action: #selector(onTooltipTap), for: .touchUpInside)

		infoStackView.addArrangedSubview(titleLabel)
		infoStackView.addArrangedSubview(tooltipImageView)

		mainStackView.addArrangedSubview(infoStackView)
		mainStackView.addArrangedSubview(betWeenView)
		mainStackView.addArrangedSubview(switcher)
	}

	private func setupConstraints() {
		mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 31).isActive = true
		infoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
		mainStackView.pin(.verticalEdges(padding: 8.5), .horizontalEdges(padding: 16))
		topBorderView.pin(.fixedHeight(0.5), .top(padding: 0), .leading(padding: 16), .trailing(padding: 0))
		tooltipImageView.pin(.fixedWidth(16), .fixedHeight(16))
	}

	private func setupStyle() {
		contentView.layer.cornerRadius = 8
		contentView.layer.maskedCorners = []
		contentView.backgroundColor = .Pino.white

		topBorderView.backgroundColor = .Pino.gray3
		topBorderView.isHidden = true

		mainStackView.axis = .horizontal
		mainStackView.alignment = .center

		titleLabel.text = customSwitchCollectionViewCellVM.title

		switcher.onTintColor = .Pino.green3

		tooltipImageView.isHidden = true
		if customSwitchCollectionViewCellVM.tooltipText != nil {
			tooltipImageView.isHidden = false
		}

		infoStackView.axis = .horizontal
		infoStackView.spacing = 1

		tooltipImageView.setImage(UIImage(named: "alert"), for: .normal)
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

	private func manageViewUsingIndex(manageIndex: manageIndexType) {
		switch manageIndex.cellIndex {
		case let index where index == manageIndex.cellsCount - 1:
			setupBottomCornerRadius()
			showTopBorder()
		case let index where index == 0:
			setupTopCornerRadius()
		case let index where index > 0:
			showTopBorder()
		default:
			break
		}
	}

	@objc
	private func onSwitcherChange() {
		switchValueClosure(switcher.isOn, customSwitchCollectionViewCellVM.type)
	}

	@objc
	private func onTooltipTap() {
		onTooltipTapClosure(customSwitchCollectionViewCellVM.title, customSwitchCollectionViewCellVM.tooltipText)
	}
}

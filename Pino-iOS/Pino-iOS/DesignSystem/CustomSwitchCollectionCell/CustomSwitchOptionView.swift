//
//  SecurityLockCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/1/23.
//

import UIKit

class CustomSwitchOptionView: UIView {
	// MARK: - Typealiases

	typealias manageIndexType = (viewIndex: Int, viewsCount: Int)
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
	private let titleLabelContainverView = UIView()

	// MARK: - Public Properties

	public var customSwitchCollectionViewCellVM: CustomSwitchOptionVM! {
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

	// MARK: - Private Methods

	private func setupView() {
		addSubview(mainStackView)
		addSubview(topBorderView)

		switcher.isOn = customSwitchCollectionViewCellVM.isSelected
		switcher.addTarget(self, action: #selector(onSwitcherChange), for: .valueChanged)

		tooltipImageView.addTarget(self, action: #selector(onTooltipTap), for: .touchUpInside)

		titleLabelContainverView.addSubview(titleLabel)

		mainStackView.addArrangedSubview(titleLabelContainverView)
		mainStackView.addArrangedSubview(tooltipImageView)

		mainStackView.addArrangedSubview(betWeenView)
		mainStackView.addArrangedSubview(switcher)
	}

	private func setupConstraints() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabelContainverView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true

		titleLabel.pin(.allEdges(padding: 0))
		mainStackView.pin(.verticalEdges(padding: 8.5), .horizontalEdges(padding: 16))
		topBorderView.pin(.fixedHeight(0.5), .top(padding: 0), .leading(padding: 16), .trailing(padding: 0))
		tooltipImageView.pin(.fixedWidth(16), .fixedHeight(16))
	}

	private func setupStyle() {
		layer.cornerRadius = 8
		layer.maskedCorners = []
		backgroundColor = .Pino.white

		topBorderView.backgroundColor = .Pino.gray3
		topBorderView.isHidden = true

		mainStackView.axis = .horizontal
		mainStackView.alignment = .center

		titleLabel.text = customSwitchCollectionViewCellVM.title
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byWordWrapping

		switcher.onTintColor = .Pino.green3

		tooltipImageView.isHidden = true
		if customSwitchCollectionViewCellVM.tooltipText != nil {
			tooltipImageView.isHidden = false
		}

		tooltipImageView.setImage(UIImage(named: "alert"), for: .normal)
	}

	private func showTopBorder() {
		topBorderView.isHidden = false
	}

	private func setupTopCornerRadius() {
		layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}

	private func setupBottomCornerRadius() {
		layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
	}

	private func setupAllCornerRadiuses() {
		layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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

	@objc
	private func onSwitcherChange() {
		switchValueClosure(switcher.isOn, customSwitchCollectionViewCellVM.type)
	}

	@objc
	private func onTooltipTap() {
		onTooltipTapClosure(customSwitchCollectionViewCellVM.title, customSwitchCollectionViewCellVM.tooltipText)
	}
}

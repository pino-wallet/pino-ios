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
	private let betWeenView = UIView()
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let titleLabelContainerView = UIView()
	private let textStackView = UIStackView()

	// MARK: - Public Properties

	public var isEnabled: Bool? {
		didSet {
			guard let isEnabled else { return }
			switcher.isEnabled = isEnabled
		}
	}

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
		switcher.addTarget(self, action: #selector(onSwitcherChange(_:)), for: .valueChanged)

		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionLabel)

		titleLabelContainerView.addSubview(textStackView)

		mainStackView.addArrangedSubview(titleLabelContainerView)

		mainStackView.addArrangedSubview(betWeenView)
		mainStackView.addArrangedSubview(switcher)
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		titleLabelContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
		descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true

		titleLabelContainerView.pin(.verticalEdges(padding: 0), .leading(padding: 0))
		mainStackView.pin(.horizontalEdges(padding: 16))
		topBorderView.pin(
			.fixedHeight(1 / UIScreen.main.scale),
			.top(padding: 0),
			.leading(padding: 16),
			.trailing(padding: 0)
		)
		textStackView.pin(.allEdges(padding: 0))
		if customSwitchCollectionViewCellVM.description != nil {
			mainStackView.pin(.verticalEdges(padding: 10))
		} else {
			mainStackView.pin(.verticalEdges(padding: 8.5))
		}
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

		descriptionLabel.font = .PinoStyle.mediumFootnote
		descriptionLabel.text = customSwitchCollectionViewCellVM.description
		descriptionLabel.isHidden = true

		if customSwitchCollectionViewCellVM.description != nil {
			descriptionLabel.isHidden = false
		}

		textStackView.axis = .vertical
		textStackView.spacing = 2
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
	private func onSwitcherChange(_ sender: UISwitch) {
		switchValueClosure(switcher.isOn, customSwitchCollectionViewCellVM.type)
	}
}

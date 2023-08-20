//
//  GroupCollectionViewStyle.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Combine
import UIKit

public class GroupCollectionViewCell: UICollectionViewCell {
	// MARK: - Internal Properties

	internal let cardView = UIView()
	internal let separatorLine = UIView()
	internal var separatorLeadingConstraint: NSLayoutConstraint!
	internal var separatorTrailingConstraint: NSLayoutConstraint!
	internal var separatorLineIsHiden: Bool?

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()

	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraints()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		contentView.addSubview(cardView)
		cardView.addSubview(separatorLine)
	}

	private func setupStyle() {
		cardView.backgroundColor = .Pino.secondaryBackground
		separatorLine.backgroundColor = .Pino.gray3

		cardView.layer.cornerRadius = 8
	}

	private func setupConstraints() {
		cardView.pin(
			.verticalEdges,
			.horizontalEdges(padding: 16)
		)
		separatorLine.pin(
			.bottom,
			.fixedHeight(0.5)
		)
		// NSLayoutConstraint is used that can be deactivated and changed in custom cells
		separatorLeadingConstraint = separatorLine.leadingAnchor.constraint(equalTo: cardView.leadingAnchor)
		separatorTrailingConstraint = separatorLine.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
		NSLayoutConstraint.activate([separatorLeadingConstraint, separatorTrailingConstraint])
	}

	private func setupBindings() {
		$style.sink { style in
			guard let style else { return }
			self.updateStyle(style)
		}.store(in: &cancellables)
	}

	private func updateStyle(_ style: GroupCollectionViewStyle) {
		cardView.layer.maskedCorners = style.maskedCorners
		if let separatorLineIsHiden {
			separatorLine.isHidden = separatorLineIsHiden
		} else {
			separatorLine.isHidden = style.separatorLineIsHidden
		}
	}

	// MARK: - Internal Properties

	@Published
	internal var style: GroupCollectionViewStyle!

	// MARK: - Public Methods

	public func setCellStyle(currentItem: Int, itemsCount: Int) {
		// We have 4 types of cells,
		// If the number of cells is 1, it'll have the single cell style
		// If the current cell index is 0, it'll have the first cell style
		// If the current cell index is equal to the number of items, it'll have the last cell style
		// Otherwise it'll have the regular style
		switch (currentItem, itemsCount) {
		case (_, 1):
			style = .singleCell
		case (0, _):
			style = .firstCell
		case (itemsCount - 1, _):
			style = .lastCell
		default:
			style = .regular
		}
	}
}

extension GroupCollectionViewCell {
	public enum GroupCollectionViewStyle {
		case regular
		case singleCell
		case firstCell
		case lastCell

		public var separatorLineIsHidden: Bool {
			switch self {
			case .regular, .firstCell:
				return false
			case .singleCell, .lastCell:
				return true
			}
		}

		public var maskedCorners: CACornerMask {
			switch self {
			case .regular:
				return []
			case .firstCell:
				return [.layerMaxXMinYCorner, .layerMinXMinYCorner]
			case .lastCell:
				return [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
			case .singleCell:
				return [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
			}
		}
	}
}

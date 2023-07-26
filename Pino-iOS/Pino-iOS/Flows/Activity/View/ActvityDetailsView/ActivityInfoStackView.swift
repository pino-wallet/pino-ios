//
//  ActivityInfoStackView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/12/23.
//

import UIKit

class ActivityInfoStackView: UIStackView {
	// MARK: - TypeAliases

	typealias ActionsheetInfoType = (title: String, description: String, show: Bool)

	// MARK: - Closures

	public var presentActionSheet: (_ actionSheet: InfoActionSheet) -> Void = { _ in }

	// MARK: - Public Properties

	public var title: String
	public var info: String? {
		didSet {
			infoLabel.text = info
		}
	}

	public var actionSheetInfo: ActionsheetInfoType
	public var infoCustomView: UIView?

	// MARK: - Private Properties

	private let betweenView = UIView()
	private let infoLabel = PinoLabel(style: .info, text: "")
	private var titleLabel: TitleWithInfo!

	// MARK: - Initializers

	init(
		title: String,
		info: String? = nil,
		actionSheetInfo: ActionsheetInfoType = (title: "", description: "", show: false),
		infoCustomView: UIView? = nil
	) {
		self.title = title
		self.info = info
		self.actionSheetInfo = actionSheetInfo
		self.infoCustomView = infoCustomView

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
		if actionSheetInfo.show {
			titleLabel = TitleWithInfo(
				actionSheetTitle: actionSheetInfo.title,
				actionSheetDescription: actionSheetInfo.description
			)
			titleLabel.presentActionSheet = { [weak self] actionSheet in
				self?.presentActionSheet(actionSheet)
			}
		} else {
			titleLabel = TitleWithInfo()
		}

		addArrangedSubview(titleLabel)
		addArrangedSubview(betweenView)
		addArrangedSubview(infoLabel)
		if infoCustomView != nil {
			addArrangedSubview(infoCustomView!)
		}
	}

	private func setupStyles() {
		axis = .horizontal
		alignment = .center

		if actionSheetInfo.show {
			titleLabel.showInfoActionSheet = true
		} else {
			titleLabel.showInfoActionSheet = false
		}

		if infoCustomView != nil {
			infoLabel.isHidden = true
		}

		titleLabel.title = title

		infoLabel.text = info
		infoLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		infoLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 160).isActive = true

		heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
	}
}

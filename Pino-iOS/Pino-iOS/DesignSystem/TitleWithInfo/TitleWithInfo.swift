//
//  TitleWithInfo.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/13/23.
//

import UIKit

class TitleWithInfo: UIView {
	// MARK: - Closures

	public var presentActionSheet: (_ actionSheet: InfoActionSheet) -> Void = { _ in }

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .description, text: "")
	private let infoActionSheetIcon = UIImageView()
	private var infoActionSheet: InfoActionSheet!

	// MARK: - Public Properties

	public var title: String! = "" {
		didSet {
			titleLabel.text = title
			titleLabel.numberOfLines = 0
		}
	}
    
    public var showInfoActionSheet: Bool = true {
        didSet {
            if showInfoActionSheet {
                infoActionSheetIcon.isHidden = false
            } else {
                infoActionSheetIcon.isHidden = true
            }
        }
    }

	// MARK: - Initializers

	init(actionSheetTitle: String = "", actionSheetDescription: String = "") {
		self.infoActionSheet = InfoActionSheet(title: actionSheetTitle, description: actionSheetDescription)

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
		mainStackView.addArrangedSubview(titleLabel)
		mainStackView.addArrangedSubview(infoActionSheetIcon)

		let iconTapGesture = UITapGestureRecognizer(target: self, action: #selector(onIconTap))
		infoActionSheetIcon.addGestureRecognizer(iconTapGesture)
		infoActionSheetIcon.isUserInteractionEnabled = true

		addSubview(mainStackView)
	}

	private func setupStyles() {
		mainStackView.axis = .horizontal
		mainStackView.spacing = 2
		mainStackView.alignment = .center

		titleLabel.font = .PinoStyle.mediumBody

		infoActionSheetIcon.image = UIImage(named: "alert")
	}

	private func setupConstraints() {
		heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

		titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 90).isActive = true

		mainStackView.pin(.allEdges(padding: 0))

		infoActionSheetIcon.pin(.fixedWidth(16), .fixedHeight(16))
	}

	@objc
	private func onIconTap() {
		presentActionSheet(infoActionSheet)
	}
}

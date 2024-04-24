//
//  RemoveAccountView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/25/23.
//

import UIKit

class RemoveAccountView: UIView {
	// MARK: - Closure

	public var dismissPage: () -> Void
	public var presentConfirmActionsheetClosure: () -> Void

	// MARK: - Public Properties

	public var removeAccountVM: RemoveAccountViewModel

	// MARK: - Private Properties

	private let clearNavigationBar = ClearNavigationBar()
	private let titleImageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptonLabel = PinoLabel(style: .description, text: "")
	private let removeButton = PinoButton(style: .delete, title: "")
	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let infoStackview = UIStackView()
	private let navigationBarRightSideView = UIView()
	private let navigationBarDismissButton = UIButton()
    private let hapticManager = HapticManager()

	// MARK: - Initializers

	init(
		presentConfirmActionsheetClosure: @escaping () -> Void,
		removeAccountVM: RemoveAccountViewModel,
		dismissPage: @escaping () -> Void
	) {
		self.presentConfirmActionsheetClosure = presentConfirmActionsheetClosure
		self.removeAccountVM = removeAccountVM
		self.dismissPage = dismissPage
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
		titleStackView.addArrangedSubview(titleImageView)
		titleStackView.addArrangedSubview(titleLabel)

		infoStackview.addArrangedSubview(descriptonLabel)

		removeButton.addTarget(self, action: #selector(presentConfirmActionsheet), for: .touchUpInside)

		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(infoStackview)

		navigationBarDismissButton.addTarget(self, action: #selector(onDismissTap), for: .touchUpInside)

		navigationBarRightSideView.addSubview(navigationBarDismissButton)

		clearNavigationBar.setRightSectionView(view: navigationBarRightSideView)

		addSubview(clearNavigationBar)
		addSubview(mainStackView)
		addSubview(removeButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		mainStackView.axis = .vertical
		mainStackView.spacing = 8
		mainStackView.alignment = .fill

		navigationBarDismissButton.setImage(
			UIImage(named: removeAccountVM.navigationDismissButtonIconName),
			for: .normal
		)

		titleImageView.image = UIImage(named: removeAccountVM.titleIconName)

		titleLabel.font = UIFont.PinoStyle.semiboldTitle2
		titleLabel.numberOfLines = 0
		titleLabel.text = removeAccountVM.titleText

		descriptonLabel.font = UIFont.PinoStyle.mediumBody
		descriptonLabel.text = removeAccountVM.describtionText

		titleStackView.axis = .vertical
		titleStackView.spacing = 24
		titleStackView.alignment = .center

		titleLabel.textAlignment = .center

		infoStackview.axis = .vertical
		infoStackview.spacing = 54

		descriptonLabel.textAlignment = .center

		removeButton.setTitle(removeAccountVM.removeButtonTitle, for: .normal)
	}

	private func setupConstraints() {
		titleImageView.pin(.fixedWidth(56), .fixedHeight(56))
		navigationBarDismissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		mainStackView.pin(
			.centerY(padding: -60),
			.centerX(to: superview),
			.horizontalEdges(padding: 16)
		)
		removeButton.pin(.bottom(to: layoutMarginsGuide, padding: 8), .horizontalEdges(padding: 16))
	}

	@objc
	private func presentConfirmActionsheet() {
        hapticManager.run(type: .heavyImpact)
		presentConfirmActionsheetClosure()
	}

	@objc
	private func onDismissTap() {
        hapticManager.run(type: .lightImpact)
		dismissPage()
	}
}

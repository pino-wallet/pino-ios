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
	private var navigationBarDismissButton: NavigationBarDismissButton!

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
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		backgroundColor = .Pino.secondaryBackground

		titleImageView.image = UIImage(named: removeAccountVM.titleIconName)

		titleLabel.font = UIFont.PinoStyle.semiboldTitle2
		titleLabel.numberOfLines = 0
		titleLabel.text = removeAccountVM.titleText

		descriptonLabel.font = UIFont.PinoStyle.mediumSubheadline
		descriptonLabel.text = removeAccountVM.describtionText

		titleStackView.axis = .vertical
		titleStackView.spacing = 24
		titleStackView.alignment = .center
		titleStackView.addArrangedSubview(titleImageView)
		titleStackView.addArrangedSubview(titleLabel)
		titleLabel.textAlignment = .center

		infoStackview.axis = .vertical
		infoStackview.spacing = 54
		infoStackview.addArrangedSubview(descriptonLabel)
		descriptonLabel.textAlignment = .center
		infoStackview.addArrangedSubview(removeButton)

		removeButton.setTitle(removeAccountVM.removeButtonTitle, for: .normal)
		removeButton.addTarget(self, action: #selector(presentConfirmActionsheet), for: .touchUpInside)

		mainStackView.axis = .vertical
		mainStackView.spacing = 16
		mainStackView.alignment = .fill
		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(infoStackview)

		navigationBarDismissButton = NavigationBarDismissButton(onDismiss: { [weak self] in
			self?.dismissPage()
		})

		clearNavigationBar.setRightSectionView(view: navigationBarDismissButton)

		addSubview(clearNavigationBar)
		addSubview(mainStackView)
	}

	private func setupConstraints() {
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		mainStackView.pin(
			.relative(.top, 119, to: clearNavigationBar, .bottom),
			.centerX(to: superview),
			.horizontalEdges(padding: 16)
		)
	}

	@objc
	private func presentConfirmActionsheet() {
		presentConfirmActionsheetClosure()
	}
}

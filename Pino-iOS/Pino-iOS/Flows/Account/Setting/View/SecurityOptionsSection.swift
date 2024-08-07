//
//  LockSettingsCollectionReusableView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/3/23.
//

import Combine
import UIKit

class SecurityOptionsSection: UICollectionReusableView {
	// MARK: - Closures

	public var openSelectLockMethodAlertClosure: (() -> Void) = {}

	// MARK: - Public Peoperties

	public var securityVM: SecuritySettingsViewModel! {
		didSet {
			setupView()
			setupConstraints()
			setupStyle()
			setupBinding()
		}
	}

	public static let viewReuseID = "LockSettingsHeaderReuseID"

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()

	private let changeLockMethodView = UIView()
	private let changeLockMethodStackView = UIStackView()
	private let changeLockMethodBetweenStackview = UIStackView()
	private let selectedLockMethodStackView = UIStackView()
	private let changeLockMethodTitleLabel = PinoLabel(style: .info, text: "")
	private let selectedLockMethodLabel = PinoLabel(style: .info, text: "")
	private let changeLockMethodDetailIcon = UIImageView()
	private let lockSettingsTitleLabel = PinoLabel(style: .description, text: "")

	// MARK: - Private Methods

	private func setupView() {
		addSubview(changeLockMethodView)
		addSubview(lockSettingsTitleLabel)

		let openSelectLockMethodGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(openSelectLockMethodModal)
		)
		changeLockMethodView.addGestureRecognizer(openSelectLockMethodGesture)

		selectedLockMethodStackView.addArrangedSubview(selectedLockMethodLabel)
		selectedLockMethodStackView.addArrangedSubview(changeLockMethodDetailIcon)

		changeLockMethodStackView.addArrangedSubview(changeLockMethodTitleLabel)
		changeLockMethodStackView.addArrangedSubview(changeLockMethodBetweenStackview)
		changeLockMethodStackView.addArrangedSubview(selectedLockMethodStackView)

		changeLockMethodView.addSubview(changeLockMethodStackView)
	}

	private func setupConstraints() {
		changeLockMethodView.pin(.top(padding: 24), .horizontalEdges(padding: 16), .fixedHeight(48))
		changeLockMethodStackView.pin(.leading(padding: 16), .trailing(padding: 8), .centerY())
		changeLockMethodDetailIcon.pin(.fixedHeight(24), .fixedWidth(24))
		lockSettingsTitleLabel.pin(.leading(padding: 16), .bottom(padding: 8))
	}

	private func setupStyle() {
		backgroundColor = .Pino.background

		changeLockMethodView.backgroundColor = .Pino.white
		changeLockMethodView.layer.cornerRadius = 7

		changeLockMethodTitleLabel.text = securityVM.changeLockMethodTitle

		selectedLockMethodLabel.textColor = .Pino.gray2

		lockSettingsTitleLabel.text = securityVM.lockSettingsHeaderTitle
		lockSettingsTitleLabel.font = .PinoStyle.mediumSubheadline

		changeLockMethodDetailIcon.image = UIImage(named: securityVM.changeLockMethodDetailIcon)?
			.withRenderingMode(.alwaysTemplate)
		changeLockMethodDetailIcon.tintColor = .Pino.gray3

		selectedLockMethodStackView.axis = .horizontal
		selectedLockMethodStackView.spacing = 2

		changeLockMethodStackView.axis = .horizontal
	}

	private func setupBinding() {
		securityVM.$selectedLockMethod.sink { lockMethod in
			self.selectedLockMethodLabel.text = lockMethod?.title
		}.store(in: &cancellables)
	}

	@objc
	private func openSelectLockMethodModal() {
		openSelectLockMethodAlertClosure()
	}
}

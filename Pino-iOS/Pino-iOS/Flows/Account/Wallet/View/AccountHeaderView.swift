//
//  AccountHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//
import UIKit

class AccountHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private let accountInfoStackview = UIStackView()
	private let accountNameStackView = UIStackView()
	private let accountIconBackgroundView = UIView()
	private let accountIcon = UIImageView()
	private let accountName = UILabel()
	private let accountAddress = UILabel()
	private let accountSettingsTitle = UILabel()
	private let accountHeaderVM = AccountHeaderViewModel()
	private let copyToastView = PinoToastView(message: nil, style: .secondary, padding: 80)

	// MARK: - Public Properties

	public static let headerReuseID = "accountHeader"

	public var accountInfoVM: AccountInfoViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			setupWalletAddressTapGesture()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		accountInfoStackview.addArrangedSubview(accountIconBackgroundView)
		accountInfoStackview.addArrangedSubview(accountNameStackView)
		accountNameStackView.addArrangedSubview(accountName)
		accountNameStackView.addArrangedSubview(accountAddress)
		accountIconBackgroundView.addSubview(accountIcon)
		addSubview(accountInfoStackview)
		addSubview(accountSettingsTitle)
	}

	private func setupStyle() {
		accountName.text = accountInfoVM.name
		accountAddress.text = accountInfoVM.address.shortenedString(characterCount: 4)
		accountSettingsTitle.text = accountHeaderVM.accountsTitleText
		accountIcon.image = UIImage(named: accountInfoVM.profileImage)
		accountIconBackgroundView.backgroundColor = UIColor(named: accountInfoVM.profileColor)
    
		accountName.textColor = .Pino.label
		accountAddress.textColor = .Pino.secondaryLabel
		accountSettingsTitle.textColor = .Pino.secondaryLabel

		accountName.font = .PinoStyle.mediumTitle1
		accountAddress.font = .PinoStyle.mediumSubheadline
		accountSettingsTitle.font = .PinoStyle.mediumSubheadline

		accountInfoStackview.axis = .vertical
		accountNameStackView.axis = .vertical

		accountNameStackView.alignment = .center
		accountInfoStackview.alignment = .center

		accountInfoStackview.spacing = 8
		accountNameStackView.spacing = 2

		accountIconBackgroundView.layer.cornerRadius = 44
	}

	private func setupConstraint() {
		accountInfoStackview.pin(
			.top(padding: 24),
			.horizontalEdges(padding: 16)
		)
		accountIconBackgroundView.pin(
			.fixedHeight(88),
			.fixedWidth(88)
		)
		accountSettingsTitle.pin(
			.bottom(padding: 12),
			.horizontalEdges(padding: 16)
		)
		accountIcon.pin(
			.allEdges(padding: 16)
		)
	}

	private func setupWalletAddressTapGesture() {
		let addressTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAddress))
		walletAddress.addGestureRecognizer(addressTapGesture)
		walletAddress.isUserInteractionEnabled = true
	}

	@objc
	private func copyAddress() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = walletInfoVM.address

		copyToastView.message = accountHeaderVM.copyMessage
		copyToastView.showToast()
	}
}

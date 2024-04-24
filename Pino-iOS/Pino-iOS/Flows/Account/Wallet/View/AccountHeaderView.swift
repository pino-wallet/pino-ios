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
	private let accountAddressInfoContainerView = UIView()
	private let accountAddressInfoStackView = UIStackView()
	private let networkImageViewContainer = UIView()
	private let networkImageView = UIImageView()
	private let accountAddress = UILabel()
	private let accountSettingsTitle = UILabel()
	private let accountHeaderVM = AccountHeaderViewModel()
    private let hapticManager = HapticManager()

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
		networkImageViewContainer.addSubview(networkImageView)

		accountAddressInfoContainerView.addSubview(accountAddressInfoStackView)
		accountAddressInfoStackView.addArrangedSubview(networkImageViewContainer)
		accountAddressInfoStackView.addArrangedSubview(accountAddress)

		accountInfoStackview.addArrangedSubview(accountIconBackgroundView)
		accountInfoStackview.addArrangedSubview(accountNameStackView)
		accountNameStackView.addArrangedSubview(accountName)
		accountNameStackView.addArrangedSubview(accountAddressInfoContainerView)
		accountIconBackgroundView.addSubview(accountIcon)
		addSubview(accountInfoStackview)
		addSubview(accountSettingsTitle)
	}

	private func setupStyle() {
		accountAddressInfoStackView.axis = .horizontal
		accountAddressInfoStackView.spacing = 6

		accountAddressInfoContainerView.backgroundColor = .Pino.secondaryBackground
		accountAddressInfoContainerView.layer.cornerRadius = 15

		networkImageView.image = UIImage(named: accountInfoVM.currentNetworkImageName)
		networkImageView.layer.cornerRadius = 10

		accountName.text = accountInfoVM.name
		accountAddress.text = accountInfoVM.address.addressFormating()
		accountSettingsTitle.text = accountHeaderVM.accountsTitleText
		accountIcon.image = UIImage(named: accountInfoVM.profileImage)
		accountIconBackgroundView.backgroundColor = UIColor(named: accountInfoVM.profileColor)

		accountName.textColor = .Pino.label
		accountAddress.textColor = .Pino.label
		accountSettingsTitle.textColor = .Pino.secondaryLabel

		accountName.font = .PinoStyle.mediumTitle1
		accountAddress.font = .PinoStyle.mediumSubheadline
		accountSettingsTitle.font = .PinoStyle.mediumSubheadline

		accountInfoStackview.axis = .vertical
		accountNameStackView.axis = .vertical

		accountNameStackView.alignment = .center
		accountInfoStackview.alignment = .center

		accountInfoStackview.spacing = 8
		accountNameStackView.spacing = 4

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
		networkImageViewContainer.pin(.fixedWidth(20))
		networkImageView.pin(.fixedHeight(20), .horizontalEdges(), .centerY, .centerX)
		accountAddressInfoContainerView.pin(.fixedHeight(30))
		accountAddressInfoStackView.pin(.horizontalEdges(padding: 6), .verticalEdges(padding: 4))
	}

	private func setupWalletAddressTapGesture() {
		let addressTapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAddress))
		accountInfoStackview.addGestureRecognizer(addressTapGesture)
		accountInfoStackview.isUserInteractionEnabled = true
	}

	@objc
	private func copyAddress() {
        hapticManager.run(type: .selectionChanged)
		let pasteboard = UIPasteboard.general
		pasteboard.string = accountInfoVM.address

		Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
	}
}

//
//  EnterSendAddressView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/15/23.
//

import Combine
import UIKit

class EnterSendAddressView: UIView {
	// MARK: - Closures

	public var tapNextButton: () -> Void = {}
	public var scanAddressQRCode: () -> Void = {}

	// MARK: - Private Propterties

	private let nextButton = PinoButton(style: .deactive)
	private let nextButtonBottomConstant = CGFloat(12)
	private let qrCodeScanButton = UIButton()
	private let suggestedAddressesVM = SuggestedAddressesViewModel()
	private let suggestedAddressesContainerView = PinoContainerCard(cornerRadius: 8)
	private var suggestedAddressesCollectionView: SuggestedAddressesCollectionView!
	private var enterSendAddressVM: EnterSendAddressViewModel
	private var scrollOverlayGradientview = UIView()
	private var keyboardHeight: CGFloat = 320 // Minimum height in rare case keyboard of height was not calculated
	private var nextButtonBottomConstraint: NSLayoutConstraint!
	private var endEditingTapGesture: UITapGestureRecognizer!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let addressTextField = PinoTextFieldView(pattern: nil)

	// MARK: - Initializers

	init(enterSendAddressVM: EnterSendAddressViewModel) {
		self.enterSendAddressVM = enterSendAddressVM

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBinding()
		setupNotifications()
		configureKeyboard()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	public func showSuggestedAddresses() {
		updateSuggestedAddressesCardHeight()

		if !suggestedAddressesVM.userWallets.isEmpty || !suggestedAddressesVM.recentAddresses.isEmpty {
			UIView.animate(withDuration: 0.3) {
				self.suggestedAddressesContainerView.alpha = 1
			}
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		suggestedAddressesCollectionView = SuggestedAddressesCollectionView(
			suggestedAddressesVM: suggestedAddressesVM,
			recentAddressDidSelect: { recentAddress in
				self.setNameWithAddressText(name: recentAddress.ensName, address: recentAddress.address)
				self.enterSendAddressVM.selectRecentAddress(name: recentAddress.ensName, address: recentAddress.address)
			},
			userWalletDidSelect: { userWallet in
				self.selectUserWallet(userWallet)
			}
		)
		addressTextField.textDidChange = {
			self.enterSendAddressVM.validateSendAddress(address: self.addressTextField.getText() ?? "")
		}

		nextButton.addAction(UIAction(handler: { _ in
			self.tapNextButton()
		}), for: .touchUpInside)

		qrCodeScanButton.addAction(UIAction(handler: { _ in
			self.scanAddressQRCode()
		}), for: .touchUpInside)

		endEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewEndEditing))
		addGestureRecognizer(endEditingTapGesture)

		suggestedAddressesContainerView.addSubview(suggestedAddressesCollectionView)
		suggestedAddressesContainerView.addSubview(scrollOverlayGradientview)
		addSubview(addressTextField)
		addSubview(suggestedAddressesContainerView)
		addSubview(nextButton)
	}

	private func setupStyles() {
		addressTextField.placeholderText = enterSendAddressVM.enterAddressPlaceholder
		nextButton.title = enterSendAddressVM.nextButtonTitle
		qrCodeScanButton.setImage(UIImage(named: enterSendAddressVM.qrCodeIconName), for: .normal)

		backgroundColor = .Pino.background
		suggestedAddressesCollectionView.backgroundColor = .Pino.clear
		scrollOverlayGradientview.backgroundColor = .Pino.clear

		suggestedAddressesContainerView.layer.masksToBounds = true
		suggestedAddressesContainerView.layer.borderWidth = 1
		suggestedAddressesContainerView.layer.borderColor = UIColor.Pino.gray5.cgColor
		suggestedAddressesContainerView.alpha = 0

		scrollOverlayGradientview.isUserInteractionEnabled = false
		endEditingTapGesture.isEnabled = false

		addressTextField.editingBegin = {
			self.endEditingTapGesture.isEnabled = true
			UIView.animate(withDuration: 0.3) {
				self.suggestedAddressesContainerView.alpha = 0
			}
			guard let recipientAddress = self.enterSendAddressVM.recipientAddress else { return }
			switch recipientAddress {
			case .ensAddress, .userWalletAddress:
				self.addressTextField.attributedText = NSMutableAttributedString(string: recipientAddress.address)
			case .regularAddress: break
			}
		}
		addressTextField.editingEnd = {
			self.endEditingTapGesture.isEnabled = false
			UIView.animate(withDuration: 0.3) {
				self.suggestedAddressesContainerView.alpha = 1
			}
			// if the entered address is for a user wallet, show its name in the  text field
			if let recipientAddress = self.enterSendAddressVM.recipientAddress,
			   let selectedWallet = self.suggestedAddressesVM.userWallets
			   .first(where: { $0.address == recipientAddress.address }) {
				self.selectUserWallet(selectedWallet)
			}

			// if the entered address is an ens address, show its name in the  text field
			if let recipientAddress = self.enterSendAddressVM.recipientAddress,
			   let selectedRecentAddress = self.suggestedAddressesVM.recentAddresses
			   .first(where: { $0.address == recipientAddress.address }),
			   let ensName = selectedRecentAddress.ensName {
				self.setNameWithAddressText(name: ensName, address: selectedRecentAddress.address)
			}
		}

		enterSendAddressVM.ensAddressFound = { name, address in
			self.setNameWithAddressText(name: name, address: address)
			self.endEditing(true)
		}
	}

	private func setupConstraints() {
		nextButtonBottomConstraint = NSLayoutConstraint(
			item: nextButton,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: layoutMarginsGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: -nextButtonBottomConstant
		)
		addConstraint(nextButtonBottomConstraint)

		addressTextField.pin(
			.top(to: layoutMarginsGuide, padding: 24),
			.horizontalEdges(padding: 16)
		)
		suggestedAddressesContainerView.pin(
			.top(to: addressTextField, .bottom, padding: 8),
			.horizontalEdges(padding: 16)
		)
		suggestedAddressesCollectionView.pin(
			.allEdges
		)
		nextButton.pin(
			.horizontalEdges(padding: 16)
		)
		scrollOverlayGradientview.pin(
			.horizontalEdges,
			.bottom,
			.fixedHeight(57)
		)
	}

	private func setupBinding() {
		enterSendAddressVM.$validationStatus.sink { validationStatus in
			self.changeViewStatus(validationStatus: validationStatus)
		}.store(in: &cancellables)
	}

	private func changeViewStatus(validationStatus: EnterSendAddressViewModel.ValidationStatus) {
		switch validationStatus {
		case let .error(error):
			addressTextField.style = .error

			nextButton.style = .deactive
			nextButton.title = error.description
		case .success:
			addressTextField.style = .success

			nextButton.style = .active
			nextButton.title = enterSendAddressVM.nextButtonTitle
		case .normal:
			addressTextField.style = .customView(qrCodeScanButton)

			nextButton.style = .deactive
			nextButton.title = enterSendAddressVM.nextButtonTitle
		case .loading:
			addressTextField.style = .pending

			nextButton.style = .deactive
			nextButton.title = enterSendAddressVM.nextButtonTitle
		}

		// ACTIVATING continue button since in devnet we don't need validation
		// to check if there is balance
		if Environment.current != .mainNet {
			nextButton.style = .active
		}
	}

	private func setupNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide(_:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	private func updateSuggestedAddressesCardHeight() {
		let collectionViewHeight = suggestedAddressesCollectionView.contentSize.height
		let maxHeight: CGFloat = layoutMarginsGuide.layoutFrame.height - 170
		if collectionViewHeight > maxHeight {
			suggestedAddressesContainerView.pin(.fixedHeight(maxHeight))
			addGradientToSuggestedAddresses()
		} else {
			suggestedAddressesContainerView.pin(.fixedHeight(collectionViewHeight))
		}
	}

	private func addGradientToSuggestedAddresses() {
		let gradientLayer = GradientLayer(frame: scrollOverlayGradientview.bounds, style: .suggestedRecipientAddress)
		scrollOverlayGradientview.layer.addSublayer(gradientLayer)
	}

	private func configureKeyboard() {
		addressTextField.textFieldKeyboardOnReturn = {
			self.endEditing(true)
		}
	}

	private func moveViewWithKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
		// Keyboard's animation duration
		let keyboardDuration = notification
			.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

		// Keyboard's animation curve
		let keyboardCurve = UIView
			.AnimationCurve(
				rawValue: notification
					.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
			)!

		// Change the constant
		if keyboardWillShow {
			let safeAreaExists = (window?.safeAreaInsets.bottom != 0) // Check if safe area exists
			let keyboardOpenConstant = keyboardHeight - (safeAreaExists ? 20 : 0)
			nextButtonBottomConstraint.constant = -keyboardOpenConstant
		} else {
			nextButtonBottomConstraint.constant = -nextButtonBottomConstant
		}

		// Animate the view the same way the keyboard animates
		let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
			// Update Constraints
			self?.layoutIfNeeded()
		}

		// Perform the animation
		animator.startAnimation()
	}

	@objc
	private func viewEndEditing() {
		endEditing(true)
	}

	private func selectUserWallet(_ userWallet: AccountInfoViewModel) {
		setNameWithAddressText(name: userWallet.name, address: userWallet.address)
		enterSendAddressVM.selectUserWallet(userWallet)
	}

	private func setNameWithAddressText(name: String?, address: String) {
		guard let name else {
			addressTextField.attributedText = NSMutableAttributedString(string: address)
			return
		}
		let formattedAddress = "(\(address.addressFormating()))"
		let addressAttributedText = NSMutableAttributedString(string: "\(name) \(formattedAddress)")
		addressAttributedText.addAttributes(
			[.font: UIFont.PinoStyle.regularBody!, .foregroundColor: UIColor.Pino.label],
			range: (addressAttributedText.string as NSString).range(of: formattedAddress)
		)
		addressAttributedText.addAttributes(
			[.font: UIFont.PinoStyle.mediumBody!, .foregroundColor: UIColor.Pino.label],
			range: (addressAttributedText.string as NSString).range(of: name)
		)
		addressTextField.attributedText = addressAttributedText
	}
}

extension EnterSendAddressView {
	@objc
	internal func keyboardWillShow(_ notification: NSNotification) {
		if let info = notification.userInfo {
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			//  Getting UIKeyboardSize.
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				let screenSize = UIScreen.main.bounds
				let intersectRect = kbFrame.intersection(screenSize)
				if intersectRect.isNull {
					keyboardHeight = 0
				} else {
					keyboardHeight = intersectRect.size.height
				}
			}
		}
		moveViewWithKeyboard(notification: notification, keyboardWillShow: true)
	}

	@objc
	internal func keyboardWillHide(_ notification: NSNotification) {
		moveViewWithKeyboard(notification: notification, keyboardWillShow: false)
	}
}

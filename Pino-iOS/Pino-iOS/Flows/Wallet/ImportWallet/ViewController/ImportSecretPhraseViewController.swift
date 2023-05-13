//
//  ImportSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/5/23.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: - PublicProperties

	public var importsecretPhraseView: ImportSecretPhraseView!
	public var validationSecretPhraseVM: ImportAccountViewModel!
	public var isNewWallet: Bool!
	public var addedNewWalletWithPrivateKey: ((String) -> Void)!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		if isNewWallet {
			setSteperView(stepsCount: 2, curreuntStep: 1)
		} else {
			setupPrimaryColorNavigationBar()
			setNavigationTitle(validationSecretPhraseVM.pageTitle)
		}
	}

	// MARK: - Private Methods

    #warning("this code needs refactoring too much nested")
	private func setupView() {
		validationSecretPhraseVM = ImportAccountViewModel(isNewWallet: isNewWallet)
		if isNewWallet {
			importsecretPhraseView = ImportSecretPhraseView(
				validationPharaseVM: validationSecretPhraseVM,
                textViewType: SecretPhraseTextView(), importBtnTapped: {
                    self.validationSecretPhraseVM.validate(
                        secretPhrase: self.importsecretPhraseView.importTextView.text,
                        onSuccess: {
                            self.importWallet()
                        },
                        onFailure: { validationError in
                            switch validationError {
                            case .invalidSecretPhrase:
                                self.importsecretPhraseView?.showError()
                            }
                        }
                    )
                }
			)
		} else {
			importsecretPhraseView = ImportSecretPhraseView(
				validationPharaseVM: validationSecretPhraseVM,
                textViewType: PrivateKeyTextView(), importBtnTapped: {
                    self.validationSecretPhraseVM.validate(
                        privateKey: self.importsecretPhraseView.importTextView.text,
                        onSuccess: {
                            self.importWallet()
                        },
                        onFailure: { validationError in
                            switch validationError {
                            case .invalidSecretPhrase:
                                self.importsecretPhraseView?.showError()
                            }
                        }
                    )
                }
			)
		}
		view = importsecretPhraseView
	}


	private func importWallet() {
		if !isNewWallet {
			addedNewWalletWithPrivateKey(importsecretPhraseView.textViewText)
		} else {
			// Go to create passcode page
			let createPasscodeViewController = CreatePasscodeViewController()
			createPasscodeViewController.pageSteps = 2
			createPasscodeViewController.walletMnemonics = importsecretPhraseView.textViewText
			navigationController?.pushViewController(createPasscodeViewController, animated: true)
		}
	}
}

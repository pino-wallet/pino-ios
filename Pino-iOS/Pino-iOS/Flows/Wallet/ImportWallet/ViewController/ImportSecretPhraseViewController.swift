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
	public var addedNewWallet: (() -> Void)!

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

	private func setupView() {
        validationSecretPhraseVM = ImportAccountViewModel(isNewWallet: isNewWallet)
        if isNewWallet {
            importsecretPhraseView = ImportSecretPhraseView(validationPharaseVM: validationSecretPhraseVM, textViewType: SecretPhraseTextView())
        } else {
            importsecretPhraseView = ImportSecretPhraseView(validationPharaseVM: validationSecretPhraseVM, textViewType: PrivateKeyTextView())
        }
		addButtonsAction()
		view = importsecretPhraseView
	}

	private func addButtonsAction() {
        if isNewWallet {
            importsecretPhraseView.importButton.addAction(UIAction(handler: { _ in
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
            }), for: .touchUpInside)
        } else {
            importsecretPhraseView.importButton.addAction(UIAction(handler: { _ in
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
            }), for: .touchUpInside)
        }
		
	}

	private func importWallet() {
		if !isNewWallet {
			addedNewWallet()
			dismiss(animated: true)
		} else {
			// Go to create passcode page
			let createPasscodeViewController = CreatePasscodeViewController()
			createPasscodeViewController.pageSteps = 2
            createPasscodeViewController.walletMnemonics = importsecretPhraseView.textViewText
			navigationController?.pushViewController(createPasscodeViewController, animated: true)
		}
	}
}

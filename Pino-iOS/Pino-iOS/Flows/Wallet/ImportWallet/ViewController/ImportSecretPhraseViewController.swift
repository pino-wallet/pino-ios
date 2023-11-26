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
	public var importAccountVM: ImportSecretPhraseViewModel!
	public var isNewWallet: Bool!
	public var addedNewWalletWithPrivateKey: ((String) -> Void)!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		if isNewWallet {
			setSteperView(stepsCount: 3, curreuntStep: 1)
		} else {
			setupPrimaryColorNavigationBar()
			setNavigationTitle(importAccountVM.pageTitle)
		}
	}

	// MARK: - Private Methods

	#warning("this code needs refactoring too much nested")
	private func setupView() {
		importAccountVM = ImportSecretPhraseViewModel(isNewWallet: isNewWallet)
		if isNewWallet {
			importsecretPhraseView = ImportSecretPhraseView(
				validationPharaseVM: importAccountVM,
				textViewType: SecretPhraseTextView(), importBtnTapped: { [unowned self] in
					let trimmedInput = cleanMnemonicInput(input: (importsecretPhraseView.importTextView.text)!)
					importAccountVM.validate(
						secretPhrase: trimmedInput,
						onSuccess: {
							self.importWallet()
						},
						onFailure: { validationError in
							switch validationError {
							case .invalidSecretPhrase:
								self.importsecretPhraseView?.showError()
								self.importsecretPhraseView?.activateButton()
							}
						}
					)
				}
			)
		} else {
			importsecretPhraseView = ImportSecretPhraseView(
				validationPharaseVM: importAccountVM,
				textViewType: PrivateKeyTextView(), importBtnTapped: { [unowned self] in
					let trimmedInput = cleanMnemonicInput(input: (importsecretPhraseView.importTextView.text)!)
					importAccountVM.validate(
						privateKey: trimmedInput,
						onSuccess: {
							self.importWallet()
						},
						onFailure: { validationError in
							switch validationError {
							case .invalidSecretPhrase:
								self.importsecretPhraseView?.showError()
								self.importsecretPhraseView?.activateButton()
							}
						}
					)
				}
			)
		}
		view = importsecretPhraseView
	}

	private func cleanMnemonicInput(input: String) -> String {
		let words = input.lowercased().components(separatedBy: .whitespacesAndNewlines)
		let trimmedWords = words.filter { !$0.isEmpty }
		return trimmedWords.joined(separator: " ")
	}

	private func importWallet() {
		let trimmedInput = cleanMnemonicInput(input: importsecretPhraseView.textViewText)
		if !isNewWallet {
			addedNewWalletWithPrivateKey(trimmedInput)
		} else {
			// Go to create passcode page
			let importAccountsVC = ImportAccountsViewController(walletMnemonics: trimmedInput)
			navigationController?.pushViewController(importAccountsVC, animated: true)
		}
	}
}

//
//  InvestDepositViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import UIKit

class InvestDepositViewController: UIViewController {
	// MARK: Private Properties

	private var investVM: InvestDepositViewModel!
	private var investView: InvestDepositView!

	// MARK: Initializers

	init(selectedAsset: InvestableAssetViewModel) {
		self.investVM = InvestDepositViewModel(selectedAsset: selectedAsset)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	override func viewDidAppear(_ animated: Bool) {
		investView.amountTextfield.becomeFirstResponder()
	}

	// MARK: - Private Methods

	private func setupView() {
		investView = InvestDepositView(
			investVM: investVM,
			nextButtonTapped: {
				self.openConfirmationPage()
			}
		)
		view = investView
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle(investVM.pageTitle)
		// Setup close button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "multiply"),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
		navigationController?.navigationBar.tintColor = .Pino.white
	}

	@objc
	private func closePage() {
		dismiss(animated: true)
	}

	private func openConfirmationPage() {}
}

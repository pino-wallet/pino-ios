//
//  EnterInviteCodeViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/30/23.
//

import UIKit

class EnterInviteCodeViewController: UIViewController {
	// MARK: - Private Properties

	private let enterInviteCodeVM = EnterInviteCodeViewModel()
	private var enterInviteCodeView: EnterInviteCodeView!

	// MARK: - Initializers

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !enterInviteCodeVM.isIcloudAvailable() {
			let icloudAlert = AlertHelper.alertController(
				title: "Warning",
				message: "To use beta you should enable iCloud in your phone",
				actions: [.ok()]
			)
			present(icloudAlert, animated: true)
		}
	}

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		enterInviteCodeView = EnterInviteCodeView(enterInviteCodeVM: enterInviteCodeVM, dismissViewClosure: {
			self.dismissSelf()
		}, presentGetInviteCodeClosure: {
			self.presentGetInviteCodePage()
		})

		view = enterInviteCodeView
	}

	private func presentGetInviteCodePage() {
		let getInviteCodePage = GetInviteCodeViewController()
		present(getInviteCodePage, animated: true)
	}

	private func dismissSelf() {
		dismiss(animated: true)
	}
}

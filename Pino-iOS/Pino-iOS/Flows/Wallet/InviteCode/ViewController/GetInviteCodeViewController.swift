//
//  GetInviteCodeViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/31/23.
//

import UIKit

class GetInviteCodeViewController: UIViewController {
	// MARK: - Private Properties

	private let getInviteCodeVM = GetInviteCodeViewModel()
	private var getInviteCodeView: GetInviteCodeView!

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
	}

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		getInviteCodeView = GetInviteCodeView(getInviteCodeVM: getInviteCodeVM, dismissViewClosure: {
			self.dismissSelf()
		})

		view = getInviteCodeView
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}

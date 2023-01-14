//
//  ManageAssetsViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

import Combine
import UIKit

class ManageAssetsViewController: UIViewController {
	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = UIView()
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.backgroundColor = .Pino.primary

		let navigationTitle = UILabel()
		navigationTitle.text = "Manage assets"
		navigationTitle.textColor = .Pino.white
		navigationTitle.font = .PinoStyle.semiboldBody
		navigationItem.titleView = navigationTitle

		navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white

		navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done)
		let textAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.white,
			NSAttributedString.Key.font: UIFont.PinoStyle.semiboldBody!,
		]
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
	}
}

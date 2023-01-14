//
//  ManageAssetsViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

import UIKit

class ManageAssetsViewController: UIViewController, UISearchControllerDelegate {
	// MARK: - Public Properties

	public var manageAssetsList: [ManageAssetViewModel]

	init(manageAssetsList: [ManageAssetViewModel]) {
		self.manageAssetsList = manageAssetsList
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
		setupSearchBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = ManageAssetsCollectionView(manageAssetsList: manageAssetsList)
		view.backgroundColor = .Pino.background
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.backgroundColor = .Pino.primary

		let navigationTitle = UILabel()
		navigationTitle.text = "Manage assets"
		navigationTitle.textColor = .Pino.white
		navigationTitle.font = .PinoStyle.semiboldBody
		navigationItem.titleView = navigationTitle

		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "plus"),
			style: .plain,
			target: self,
			action: #selector(addCustomAssets)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white

		let textAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.white,
			NSAttributedString.Key.font: UIFont.PinoStyle.semiboldBody!,
		]
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .plain,
			target: self,
			action: #selector(dismissManageAsset)
		)
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
	}

	@objc
	private func dismissManageAsset() {
		dismiss(animated: true)
	}

	@objc
	private func addCustomAssets() {}

	private func setupSearchBar() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.searchTextField.tintColor = .Pino.green2
		searchController.searchBar.searchTextField.leftView?.tintColor = .Pino.green2
		searchController.searchBar.showsBookmarkButton = true
		searchController.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: [])

		searchController.delegate = self
		searchController.searchBar.delegate = self
		searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
			string: "Search",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.Pino.green2]
		)

		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.searchController?.searchBar.searchTextField.textColor = .Pino.white
	}
}

//
//  ManageAssetsViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

import UIKit

class ManageAssetsViewController: UIViewController {
	// MARK: - Public Properties

	public var homeVM: HomepageViewModel

	private var manageAssetCollectionview: ManageAssetsCollectionView

	init(homeVM: HomepageViewModel) {
		self.homeVM = homeVM
		self.manageAssetCollectionview = ManageAssetsCollectionView(homeVM: homeVM)
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

	override func viewWillDisappear(_ animated: Bool) {
		homeVM.saveAssetsInUserDefaults(assets: homeVM.manageAssetsList.compactMap { $0.assetModel })
	}

	// MARK: - Private Methods

	private func setupView() {
		view = manageAssetCollectionview
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
		searchController.searchResultsUpdater = self
		searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
			string: "Search",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.Pino.green2]
		)

		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.searchController?.searchBar.searchTextField.textColor = .Pino.white
	}
}

extension ManageAssetsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let searchText = searchController.searchBar.searchTextField.text, searchText != "" {
			manageAssetCollectionview.filteredAssets = homeVM.manageAssetsList
				.filter { $0.name.lowercased().contains(searchText.lowercased()) }
		} else {
			manageAssetCollectionview.filteredAssets = homeVM.manageAssetsList
		}
	}
}

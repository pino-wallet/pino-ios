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

	// MARK: Private Properties

	private var manageAssetCollectionview: ManageAssetsCollectionView

	// MARK: Initializers

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
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Manage assets")
		// Setup add asset button
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "plus"),
			style: .plain,
			target: self,
			action: #selector(addCustomAssets)
		)
		navigationItem.leftBarButtonItem?.tintColor = .Pino.white
		// Setup done button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .plain,
			target: self,
			action: #selector(dismissManageAsset)
		)
	}

	@objc
	private func dismissManageAsset() {
		dismiss(animated: true)
	}

	@objc
	private func addCustomAssets() {
		let addCustomAssetVC = AddCustomAssetViewController()
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [addCustomAssetVC]
		present(navigationVC, animated: true)
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

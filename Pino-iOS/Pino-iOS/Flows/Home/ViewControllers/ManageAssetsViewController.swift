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
	private var manageAssetEmptyStateView: ManageAssetEmptyStateView!
	private var assetsList: [AssetViewModel]
	private var positionsVM: ManageAssetPositionsViewModel

	// MARK: Initializers

	init(homeVM: HomepageViewModel) {
		self.homeVM = homeVM
		self.assetsList = GlobalVariables.shared.manageAssetsList?.filter { $0.isPosition == false } ?? []
		self.positionsVM = ManageAssetPositionsViewModel(
			positions: GlobalVariables.shared.manageAssetsList?.filter { $0.isPosition && !$0.holdAmount.isZero } ?? []
		)
		self.manageAssetCollectionview = ManageAssetsCollectionView(assets: assetsList, positionsVM: positionsVM)
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
		// Save selected assets locally
	}

	// MARK: - Private Methods

	private func setupView() {
		manageAssetEmptyStateView = ManageAssetEmptyStateView(onImportButton: {
			self.addCustomAssets()
		})

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
		// Setup done button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .plain,
			target: self,
			action: #selector(dismissManageAsset)
		)
	}

	private func toggleView() {
		if manageAssetCollectionview.filteredAssets.isEmpty {
			view = manageAssetEmptyStateView
		} else {
			view = manageAssetCollectionview
		}
	}

	@objc
	private func dismissManageAsset() {
		dismiss(animated: true)
	}

	@objc
	private func addCustomAssets() {
		let addCustomAssetVC = AddCustomAssetViewController(
			userAddress: homeVM.walletInfo.address
		) { customAsset in
			AssetManagerViewModel.shared.addNewCustomAsset(customAsset)
			self.dismiss(animated: true)
		}
		let navigationVC = UINavigationController()
		navigationVC.viewControllers = [addCustomAssetVC]
		present(navigationVC, animated: true)
	}
}

extension ManageAssetsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let searchTextLowerCased = searchController.searchBar.searchTextField.text?.lowercased(),
		   searchTextLowerCased != "" {
			manageAssetCollectionview.positionsVM = nil
			manageAssetCollectionview.filteredAssets = assetsList
				.filter {
					$0.name.lowercased().contains(searchTextLowerCased) || $0.symbol.lowercased()
						.contains(searchTextLowerCased)
				}
			toggleView()
		} else {
			manageAssetCollectionview.positionsVM = positionsVM
			manageAssetCollectionview.filteredAssets = assetsList
		}
	}
}

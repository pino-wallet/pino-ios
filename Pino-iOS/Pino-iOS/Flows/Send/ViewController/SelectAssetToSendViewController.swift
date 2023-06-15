//
//  SelectAssetToSendViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Combine
import UIKit

class SelectAssetToSendViewController: UIViewController {
	// MARK: - Private Properties

	private let selectAssetToSendVM: SelectAssetToSendViewModel
	private var selectAssetcollectionView: SelectAssetCollectionView!
	private var cancellables = Set<AnyCancellable>()
	private let assets: [AssetViewModel]

	// MARK: - Public Properties

	public var changeAssetFromEnterAmountPage: ((AssetViewModel) -> Void)?

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
		setupBindings()
	}

	// MARK: - Initializers

	init(assets: [AssetViewModel]) {
		self.selectAssetToSendVM = SelectAssetToSendViewModel(assetsList: assets)
		self.assets = assets
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(selectAssetToSendVM.pageTitle)
		setupSearchBar()
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: selectAssetToSendVM.dissmissIocnName),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
	}

	private func setupView() {
		selectAssetcollectionView = SelectAssetCollectionView(selectAssetVM: selectAssetToSendVM)
		selectAssetcollectionView.didSelectAsset = { selectedAsset in
			if let selectedAssetChanged = self.changeAssetFromEnterAmountPage {
				selectedAssetChanged(selectedAsset)
				self.dismissSelf()
			} else {
				self.openEnterAmountPage(selectedAsset: selectedAsset)
			}
		}
		view = selectAssetcollectionView
	}

	private func setupBindings() {
		selectAssetToSendVM.$filteredAssetList.sink { [weak self] _ in
			self?.selectAssetcollectionView.reloadData()
		}.store(in: &cancellables)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}

	private func openEnterAmountPage(selectedAsset: AssetViewModel) {
		let enterAmountVC = EnterSendAmountViewController(selectedAsset: selectedAsset, assets: assets)
		navigationController?.pushViewController(enterAmountVC, animated: true)
	}
}

extension SelectAssetToSendViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		selectAssetToSendVM.updateFilteredAndSearchedAssetList(searchValue: searchController.searchBar.text!)
	}
}

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
	private let hapticManager = HapticManager()
	private var onDismiss: ((SendTransactionStatus) -> Void)?
	private var emptyStateView: TokensEmptyStateView!

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

	init(assets: [AssetViewModel], onDismiss: ((SendTransactionStatus) -> Void)?) {
		self.selectAssetToSendVM = SelectAssetToSendViewModel(assetsList: assets)
		self.assets = assets
		self.onDismiss = onDismiss
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
			self.hapticManager.run(type: .selectionChanged)
			if let selectedAssetChanged = self.changeAssetFromEnterAmountPage {
				selectedAssetChanged(selectedAsset)
				self.navigationController?.dismiss(animated: true)
			} else {
				self.openEnterAmountPage(selectedAsset: selectedAsset)
			}
		}

		emptyStateView = TokensEmptyStateView(tokensEmptyStateTexts: .noResults, onDismissKeyboard: {
			self.navigationItem.searchController?.searchBar.resignFirstResponder()
		})

		view = selectAssetcollectionView
	}

	private func updateViewWithStatus(pageStatus: SelectAssetToSendViewModel.PageStatus) {
		switch pageStatus {
		case .searchEmptyAssets:
			emptyStateView.tokensEmptyStateTexts = .noResults
			view = emptyStateView
		case .emptyAssets:
			emptyStateView.tokensEmptyStateTexts = .noAssetsSend
			view = emptyStateView
		case .normal:
			view = selectAssetcollectionView
		}
	}

	private func setupBindings() {
		selectAssetToSendVM.$filteredAssetList.sink { [weak self] filteredAssetsList in
			self?.selectAssetcollectionView.reloadData()
		}.store(in: &cancellables)
		selectAssetToSendVM.$pageStatus.sink { [weak self] pageStatus in
			self?.updateViewWithStatus(pageStatus: pageStatus)
		}.store(in: &cancellables)
	}

	@objc
	private func dismissSelf() {
		hapticManager.run(type: .selectionChanged)
		dismiss(animated: true)
	}

	private func openEnterAmountPage(selectedAsset: AssetViewModel) {
		let enterAmountVC = EnterSendAmountViewController(
			selectedAsset: selectedAsset,
			assets: assets,
			onSendConfirm: { pageStatus in
				self.onDismiss?(pageStatus)
			}
		)
		navigationController?.pushViewController(enterAmountVC, animated: true)
	}
}

extension SelectAssetToSendViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		selectAssetToSendVM.updateFilteredAndSearchedAssetList(searchValue: searchController.searchBar.text!)
	}
}

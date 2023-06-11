//
//  SelectAssetToSendViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import UIKit

class SelectAssetToSendViewController: UIViewController {
    // MARK: - Public Properties
    private let selectAssetToSendVM: SelectAssetToSendViewModel
    private var selectAssetcollectionView: SelectAssetCollectionView!

    // MARK: - View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        setupView()
        setupNavigationBar()
    }
    
    // MARK: - Initializers
    init(selectAssetToSendVM: SelectAssetToSendViewModel) {
        self.selectAssetToSendVM = selectAssetToSendVM
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: selectAssetToSendVM.dissmissIocnName), style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    private func setupView() {
        selectAssetcollectionView = SelectAssetCollectionView(selectAssetVM: selectAssetToSendVM)
        selectAssetcollectionView.didSelectAsset = { [weak self] selectedAsset in
            print(selectedAsset)
        }
        view = selectAssetcollectionView
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
   

}

extension SelectAssetToSendViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

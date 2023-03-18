//
//  CreateImportViewController.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/15/23.
//

import UIKit

class AddNewWalletViewController: UIViewController {
    
    private let addNewWalletVM = AddNewWalletViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        setupView()
        setupNavigationBar()
    }
    
    
    
    
    private func setupView() {
        view = AddNewWalletCollectionView(addNewWalletVM: addNewWalletVM, openAddNewWalletPageClosure: { [weak self] option in
            self?.openAddNewWalletPage(option: option)
        })
    }
    
    
    private func setupNavigationBar() {
        setNavigationTitle("Create / Import wallet")
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow_left"), style: .plain, target: self, action: #selector(goToPrevPage))
    }
    
    private func openAddNewWalletPage(option: AddNewWalletOptionModel) {
        switch option.page {
        case .Create:
            let createWalletVC = ShowSecretPhraseViewController()
            navigationController?.pushViewController(createWalletVC, animated: true)
        case .Import:
            let importWalletVC = ImportSecretPhraseViewController()
            navigationController?.pushViewController(importWalletVC, animated: true)
        }
            }
    
    @objc private func goToPrevPage() {
        navigationController?.popViewController(animated: true)
    }
    

}

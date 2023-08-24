//
//  BorrowSelectDexViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import UIKit

class BorrowSelectDexViewController: UIViewController {
    // MARK: - Closures
    public var dexSystemDidSelectClosure: (DexSystemModel) -> Void
    // MARK: - Private Properties
    private let borrowSelectDexVM = BorrowSelectDexViewModel()
    private var selectDexSystemCollectionView: SelectDexSystemCollectionView!

    // MARK: - View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - Initializers
    init(dexSystemDidSelectClosure: @escaping (DexSystemModel) -> Void) {
        self.dexSystemDidSelectClosure = dexSystemDidSelectClosure
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    
    private func setupView() {
        selectDexSystemCollectionView = SelectDexSystemCollectionView(selectDexSystemVM: borrowSelectDexVM, dexProtocolDidSelect: { selectedDexSystem in
            self.dexSystemDidSelectClosure(selectedDexSystem)
            self.dismiss(animated: true)
        })
        
        view = selectDexSystemCollectionView
    }
    
    private func setupNavigationBar() {
        setupPrimaryColorNavigationBar()
        setNavigationTitle(borrowSelectDexVM.pageTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: borrowSelectDexVM.dissmissButtonImageName), style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

}

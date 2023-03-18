//
//  CreateImportWalletCollectionView.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import UIKit

class AddNewWalletCollectionView: UICollectionView {
    
    public typealias openAddNewWalletPageClosureType = (AddNewWalletOptionModel) -> Void
    
    public var openAddNewWalletPageClosure: openAddNewWalletPageClosureType
    
    public let addNewWalletVM: AddNewWalletViewModel
    
    init(addNewWalletVM: AddNewWalletViewModel, openAddNewWalletPageClosure: @escaping openAddNewWalletPageClosureType) {
        self.addNewWalletVM = addNewWalletVM
        self.openAddNewWalletPageClosure = openAddNewWalletPageClosure
        let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
        flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.collectionView?.backgroundColor = .Pino.background
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        register(AddNewWalletCollectionViewCell.self, forCellWithReuseIdentifier: AddNewWalletCollectionViewCell.cellReuseID)
        
        delegate = self
        dataSource = self
    }
}

extension AddNewWalletCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAddNewWalletOption = addNewWalletVM.AddNewWalletOptions[indexPath.item]
        openAddNewWalletPageClosure(selectedAddNewWalletOption!)
    }
}


// MARK: Collection View Flow Layout

extension AddNewWalletCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: 76)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension AddNewWalletCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addNewWalletVM.AddNewWalletOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addNewWalletCell = dequeueReusableCell(withReuseIdentifier: AddNewWalletCollectionViewCell.cellReuseID, for: indexPath) as! AddNewWalletCollectionViewCell
        addNewWalletCell.addNewWalletOptionVM = AddNewWalletOptionViewModel(AddNewWalletOption: addNewWalletVM.AddNewWalletOptions[indexPath.item]!)
        
        return addNewWalletCell
    }
    
    
}


//
//  CoinInfoCollectionView.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/18/23.
//

import UIKit
import Combine

class CoinInfoCollectionView: UICollectionView {
    
    //MARK: -Private Properties
    
    private var cacncellabel = Set<AnyCancellable>()
    private let historyRefreshContorl = UIRefreshControl()
    private let refreshErrorTostView = PinoToastView()
    
    
    //MARK: - Internal Properties
    internal var coinInfoVM: CoinInfoPageViewModel!
    

    //MARK: - Initializers
    
    init(coinInfoVM:CoinInfoPageViewModel){
        self.coinInfoVM = coinInfoVM
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        configCollectionView()
        setupView()
        setUpStyle()
        setupBinding()
    }
    
    
    
    required init?(coder aDecoder:NSCoder) {
        fatalError()
    }
    
    
    //MARK: - Private Methods
    
    private func configCollectionView(){
        register(CoinInfoHeaderView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier:CoinInfoHeaderView.headerReuseID)
        register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: HistoryCollectionViewCell.cellID)
        register(ResentHistoryHeaderView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier:ResentHistoryHeaderView.headerReuseID)
        dataSource = self
        delegate = self
    }
    
    private func setupView(){
        setupRefreshControl()
        setupErrorTostView()
    }
    
    private func setUpStyle() {
        backgroundColor = .Pino.clear
        showsVerticalScrollIndicator = false
    }
    
    private func setupBinding() {
        coinInfoVM.$historyList.sink { [weak self] _ in
            self?.reloadData()
        }.store(in: &cacncellabel)
    }
    
    private func setupErrorTostView() {
        addSubview(refreshErrorTostView)
        refreshErrorTostView.pin(.top(padding: -8),
                                 .centerX)
    }
    
    private func setupRefreshControl() {
        indicatorStyle = .white
        historyRefreshContorl.tintColor = .Pino.green2
        historyRefreshContorl.addAction(UIAction(handler: { _ in
            self.refreshData()
        }), for: .valueChanged)
        refreshControl = historyRefreshContorl
    }
    
    private func refreshData(){
        coinInfoVM.refreshCoinInfoData { error in
            self.refreshControl?.endRefreshing()
            if let error{
                switch error{
                case .requestFaild:
                    self.refreshErrorTostView.message = self.coinInfoVM.requestFailedErrorToastMessage
                case.networkingConnection:
                    self.refreshErrorTostView.message = self.coinInfoVM.connectionErrorToastMessage
                }
                self.refreshErrorTostView.showToast()
            }
        }
    }
}

extension CoinInfoCollectionView:UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 72)
    }
}


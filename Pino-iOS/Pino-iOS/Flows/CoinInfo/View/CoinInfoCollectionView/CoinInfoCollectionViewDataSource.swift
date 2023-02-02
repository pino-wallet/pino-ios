//
//  CoinInfoCollectionViewDataSource.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/18/23.
//

import UIKit

extension CoinInfoCollectionView:UICollectionViewDataSource{
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else
        {
            return coinInfoVM.historyList.count
        }
    }
    
    
    
    
    private func coinInfoHeaderView(kind:String,indexPath: IndexPath) -> UICollectionReusableView?{
        let coinInfoHeaderView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CoinInfoHeaderView.headerReuseID, for: indexPath) as! CoinInfoHeaderView
        coinInfoHeaderView.coinInfoVM = coinInfoVM
        return coinInfoHeaderView
    }
    
    func recentHistoryHeaderView(kind:String,indexPath: IndexPath) -> UICollectionReusableView{
        let recentHistoryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ResentHistoryHeaderView.headerReuseID, for: indexPath) as! ResentHistoryHeaderView
        recentHistoryView.title = "Recent history"
        return recentHistoryView
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section{
        case 0:
            return coinInfoHeaderView(kind: kind, indexPath: indexPath) as! CoinInfoHeaderView
        case 1:
            return recentHistoryHeaderView(kind: kind, indexPath: indexPath) as! ResentHistoryHeaderView
        default:
            return coinInfoHeaderView(kind: kind, indexPath: indexPath) as! CoinInfoHeaderView
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }else{
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }

    
    
//    internal func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: collectionView.frame.width, height: 390)
//        }else
//        {
//            return CGSize(width: collectionView.frame.width, height: 50)
//        }
//    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let historyCell = dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.cellID, for: indexPath) as! HistoryCollectionViewCell
        historyCell.historyCoinInfoVM = coinInfoVM.historyList[indexPath.row]
        return historyCell
    }
    
}




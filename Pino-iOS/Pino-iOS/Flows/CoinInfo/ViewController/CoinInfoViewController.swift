//
//  CoinInfoViewController.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/5/23.
//

import UIKit
import Combine
class CoinInfoViewController: UIViewController {
    
    
    //MARK: - Private Properties
    
    private let coinInfoVM = CoinInfoPageViewModel()
    private var cacnellabeles = Set<AnyCancellable>()
        
    //MARK: - viewOverrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = GradientLayer(frame: view.bounds, style: .homeBackground)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func loadView() {
        setUpView()
        setupNavigationBar()
    }
    
    //MARK: - private Methods
    private func setUpView(){
        view = UIView()
        let coinInfoCollectionView = CoinInfoCollectionView(coinInfoVM: coinInfoVM)
        view.addSubview(coinInfoCollectionView)
        coinInfoCollectionView.pin(.allEdges)
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .Pino.primary
        navigationItem.leftBarButtonItem = CoinInfoNavigationItems.closeButton
        navigationItem.rightBarButtonItem = CoinInfoNavigationItems.chartButton
        navigationItem.titleView = CoinInfoNavigationItems.coinTitle
    }
    
}

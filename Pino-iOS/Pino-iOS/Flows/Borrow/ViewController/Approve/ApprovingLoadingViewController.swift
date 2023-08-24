//
//  ApprovingLoadingViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/24/23.
//

import UIKit

class ApprovingLoadingViewController: UIViewController {

    // MARK: - Private Properties
    
    private let approveLoadingVM = ApprovingLoadingViewModel()
    private var approveLoadingView: ApprovingLoadingView!
    
    // MARK: - View Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        setupPrimaryColorNavigationBar()
//        setNavigationTitle(borrowVM.pageTitle)
    }
    
    private func setupView() {
        approveLoadingView = ApprovingLoadingView(approvingLoadingVM: approveLoadingVM)
        
        view = approveLoadingView
    }
}

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
    private var swapConfirmationVM: SwapConfirmationViewModel!
    
    // MARK: - Initilizers
    
    init(swapConfirmationVM: SwapConfirmationViewModel) {
        self.swapConfirmationVM = swapConfirmationVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.openConfirmationPage()
        }
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
    }
    
    private func setupView() {
        approveLoadingView = ApprovingLoadingView(approvingLoadingVM: approveLoadingVM)
        view = approveLoadingView
    }
    
    private func openConfirmationPage() {
        let confirmationVC = SwapConfirmationViewController(swapConfirmationVM: swapConfirmationVM)
        let confirmationNavigationVC = UINavigationController(rootViewController: confirmationVC)
        present(confirmationNavigationVC, animated: true)
    }
}

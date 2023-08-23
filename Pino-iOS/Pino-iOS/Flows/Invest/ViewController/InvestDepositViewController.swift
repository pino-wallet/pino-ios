//
//  InvestDepositViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import UIKit

class InvestDepositViewController: UIViewController {
    // MARK: Private Properties

    private var investVM: InvestableAssetViewModel!
    private var investView: UIView!

    // MARK: Initializers

    init(selectedAsset: InvestableAssetViewModel) {
        self.investVM = selectedAsset
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        setupView()
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
//        investView.amountTextfield.becomeFirstResponder()
    }

    // MARK: - Private Methods

    private func setupView() {
        investView = UIView()
//        investView = EnterSendAmountView(
//            investVM: investVM,
//            nextButtonTapped: {
//                self.openConfirmationPage()
//            }
//        )
        view = investView
    }

    private func setupNavigationBar() {
        // Setup appreance for navigation bar
        setupPrimaryColorNavigationBar()
        // Setup title view
        setNavigationTitle("Invest in \(investVM.assetName)")
    }
    
    private func openConfirmationPage() {
        
    }
}

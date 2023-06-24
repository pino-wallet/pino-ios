//
//  SendConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import UIKit

class SendConfirmationViewController: AuthenticationLockViewController {
    // MARK: Private Properties
    
    private let sendConfirmationVM: SendConfirmationViewModel
    
    // MARK: Initializers
    
    init(sendConfirmationVM: SendConfirmationViewModel) {
        self.sendConfirmationVM = sendConfirmationVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try sendConfirmationVM.getFee().catch { error in
                Toast.default(title: "\(error)", subtitle: "Please try again!", style: .error).show(haptic: .warning)
            }
        } catch {
            Toast.default(title: "\(error)", subtitle: "Please try again!", style: .error).show(haptic: .warning)
        }
    }
    
    override func loadView() {
        setupView()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view = SendConfirmationView(
            sendConfirmationVM: sendConfirmationVM,
            confirmButtonTapped: {
                self.confirmSend()
            },
            presentFeeInfo: { feeInfoActionSheet in
                self.showFeeInfoActionSheet(feeInfoActionSheet)
            }
        )
    }
    
    private func setupNavigationBar() {
        // Setup appreance for navigation bar
        setupPrimaryColorNavigationBar()
        // Setup title view
        setNavigationTitle("Confirm transfer")
    }
    
    private func showFeeInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet) {
        present(feeInfoActionSheet, animated: true)
    }
    
    private func confirmSend() {
        unlockApp {
            let statusPageVC = SendStatusViewController(confirmationVM: self.sendConfirmationVM) {
                self.dismiss(animated: true)
            }
//            self.present(statusPageVC, animated: true)
        }
    }
}

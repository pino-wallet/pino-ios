//
//  SendStatusViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/18/23.
//

import UIKit
import Web3_Utility

class SendStatusViewController: UIViewController {
	// MARK: - Private Properties

    private let coreDataManager = CoreDataManager()
    private let walletManager = PinoWalletManager()
    private let activityHelper = ActivityHelper()
	private var sendStatusView: SendStatusView!
	private var confirmationVM: SendConfirmationViewModel

	// MARK: - Initializers

	init(confirmationVM: SendConfirmationViewModel) {
		self.confirmationVM = confirmationVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		clearNavbar()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()

		confirmationVM.sendToken().done { [self] trxHash in
			sendStatusView.pageStatus = .success
            let userAddress = walletManager.currentAccount.eip55Address
            coreDataManager.addNewTransferActivity(activityModel: ActivityTransferModel(txHash: trxHash, type: "transfer", detail: TransferActivityDetail(amount: Utilities.parseToBigUInt(confirmationVM.sendAmount, units: .custom(confirmationVM.selectedToken.decimal))!.description, tokenID: confirmationVM.selectedToken.id, from: userAddress, to: confirmationVM.recipientAddress), fromAddress: userAddress, toAddress: confirmationVM.recipientAddress, blockTime: activityHelper.getServerFormattedStringDate(date: Date()), gasUsed: confirmationVM.gasLimit, gasPrice: confirmationVM.gasPrice), accountAddress: userAddress)
                PendingActivitiesManager.shared.startActivityPendingRequests()
		}.catch { [self] error in
			sendStatusView.pageStatus = .failed
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		sendStatusView = SendStatusView(toggleIsModalInPresentation: { isModelInPresentation in
			self.isModalInPresentation = isModelInPresentation
		})
		sendStatusView.onDissmiss = {
			self.dismiss(animated: true)
		}
		view = sendStatusView
	}
}

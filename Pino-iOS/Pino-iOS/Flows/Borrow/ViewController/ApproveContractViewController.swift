//
//  ApproveContractViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Foundation
import UIKit

class ApproveContractViewController: UIViewController {
    // MARK: - Private Properties
    private var approveContractVM = ApproveContractViewModel()
    private var approveContractView: ApproveContractView!
	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
        setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
        approveContractView = ApproveContractView(approveContractVM: approveContractVM, onApproveTap: {
            #warning("do approve job here")
        })
        
		view = approveContractView
	}
    
    private func setupNavigationBar() {
        setupPrimaryColorNavigationBar()
        setNavigationTitle(approveContractVM.pageTitle)
    }
}

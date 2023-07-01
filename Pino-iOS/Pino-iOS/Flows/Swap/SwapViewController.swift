//
//  SwapViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/17/22.
//

import UIKit

class SwapViewController: UIViewController {
	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		let ethToken = HomepageViewModel.sharedAssets.first(where: { $0.isEth })
		let enterAmountVM = EnterSendAmountViewModel(selectedToken: ethToken!, ethPrice: ethToken!.price)
		view = SwapView(swapVM: enterAmountVM, changeSelectedToken: {}, nextButtonTapped: {})
	}
}

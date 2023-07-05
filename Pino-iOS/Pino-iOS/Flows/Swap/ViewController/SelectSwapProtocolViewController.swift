//
//  SelectSwapProtocolViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import UIKit

class SelectSwapProtocolViewController: UIViewController {
	// MARK: - Private Properties

	private var swapProtocolVM = SelectSwapProtocolViewModel()
	private var swapProtocolCollectionView: SwapProtocolCollectionView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(swapProtocolVM.pageTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: swapProtocolVM.dissmissIocn),
			style: .plain,
			target: self,
			action: #selector(closePage)
		)
	}

	private func setupView() {
		swapProtocolCollectionView = SwapProtocolCollectionView(
			swapProtocols: swapProtocolVM.swapProtocols,
			protocolDidSelect: { selectedProtocol in
				self.closePage()
			}
		)
		view = swapProtocolCollectionView
	}

	@objc
	private func closePage() {
		dismiss(animated: true)
	}
}

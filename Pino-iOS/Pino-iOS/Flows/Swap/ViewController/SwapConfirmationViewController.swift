//
//  SwapConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import UIKit
import Combine

class SwapConfirmationViewController: AuthenticationLockViewController {
	// MARK: Private Properties

	let swapConfirmationVM: SwapConfirmationViewModel
    let swapAPIClient = ParaSwapAPIClient()
    private var cancellables = Set<AnyCancellable>()

    
	// MARK: Initializers

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
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        confirmSwap()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = SwapConfirmationView(
			swapConfirmationVM: swapConfirmationVM,
			confirmButtonTapped: {},
			presentFeeInfo: { infoActionSheet in },
			retryFeeCalculation: {}
		)
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Confirm swap")
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "dissmiss"),
			style: .plain,
			target: self,
			action: #selector(dismissPage)
		)
	}

	private func showFeeInfoActionSheet(_ feeInfoActionSheet: InfoActionSheet) {
		present(feeInfoActionSheet, animated: true)
	}

	private func confirmSwap() {
        let swapInfo = SwapPriceRequestModel(
            srcToken: "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE",
            srcDecimals: 18,
            destToken: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            destDecimals: 6,
            amount: "1000000000000000000",
            side: .sell)
        swapAPIClient.swapPrice(swapInfo: swapInfo).sink { completed in
            switch completed {
            case .finished:
                print("Token activities received successfully")
            case let .failure(error):
                print(error)
            }
        } receiveValue: { responseReq in
            print(responseReq)
        }.store(in: &cancellables)

		unlockApp {}
	}

	@objc
	private func dismissPage() {
		dismiss(animated: true)
	}
}

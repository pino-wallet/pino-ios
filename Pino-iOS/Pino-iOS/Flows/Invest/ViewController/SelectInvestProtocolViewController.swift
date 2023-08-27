//
//  SelectInvestProtocolViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/27/23.
//

import UIKit

class SelectInvestProtocolViewController: UIViewController {
	// MARK: - Closures

	public var protocolDidChange: (InvestProtocolViewModel) -> Void

	// MARK: - Private Properties

	private let selectInvestProtocolVM = SelectInvestProtocolViewModel()
	private var selectDexSystemCollectionView: SelectDexSystemCollectionView!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupNavigationBar()
		setupView()
	}

	// MARK: - Initializers

	init(protocolDidChange: @escaping (InvestProtocolViewModel) -> Void) {
		self.protocolDidChange = protocolDidChange

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		selectDexSystemCollectionView = SelectDexSystemCollectionView(
			selectDexSystemVM: selectInvestProtocolVM,
			dexProtocolDidSelect: { selectedDexSystem in
				self.protocolDidChange(selectedDexSystem as! InvestProtocolViewModel)
				self.dismiss(animated: true)
			}
		)

		view = selectDexSystemCollectionView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(selectInvestProtocolVM.pageTitle)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "dismiss"),
			style: .plain,
			target: self,
			action: #selector(dismissSelf)
		)
	}

	@objc
	private func dismissSelf() {
		dismiss(animated: true)
	}
}

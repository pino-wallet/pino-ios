//
//  Navigation+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/25/22.
//

import UIKit

extension UIViewController {
	// MARK: Public Methods

	public func setSteperView(stepsCount: Int, curreuntStep: Int) {
		// Show steper view in the navigation bar
		let stepperView = PinoStepperView(stepsCount: stepsCount, currentStep: curreuntStep)
		navigationItem.titleView = stepperView
		navigationController?.navigationBar.topItem?.title = ""
	}

	public func removeNavigationBackButton() {
		// Lock back button in the navigation bar
		let backButton = UIBarButtonItem(
			image: nil,
			style: .plain,
			target: self,
			action: nil
		)
		navigationItem.setLeftBarButton(backButton, animated: false)
	}

	public func setNavigationTitle(_ title: String) {
		let navigationTitle = UILabel()
		navigationTitle.text = title
		navigationTitle.textColor = .Pino.white
		navigationTitle.font = .PinoStyle.semiboldBody
		navigationItem.titleView = navigationTitle
	}

	public func setupPrimaryColorNavigationBar() {
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		navBarAppearance.backgroundColor = .Pino.primary

		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.topItem?.title = ""
	}

	public func setupSearchBar() {
		guard let self = self as? UISearchResultsUpdating else {
			fatalError("View controller doesn't confirm to UISearchResultUpdating protocol")
		}
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.searchTextField.tintColor = .Pino.green2
		searchController.searchBar.searchTextField.leftView?.tintColor = .Pino.green2
		searchController.searchResultsUpdater = self
		searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
			string: "Search",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.Pino.green2]
		)
		if let clearButton = searchController.searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
			let clearButtonImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
			clearButton.setImage(clearButtonImage, for: .normal)
			clearButton.tintColor = .Pino.green2
		}
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.searchController?.searchBar.searchTextField.textColor = .Pino.white

		let textAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.Pino.white,
			NSAttributedString.Key.font: UIFont.PinoStyle.semiboldBody!,
		]

		let cancelButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
		let offset = UIOffset(horizontal: 0, vertical: 3)
		cancelButton.setTitlePositionAdjustment(offset, for: .default)

		UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes, for: .normal)
	}
}

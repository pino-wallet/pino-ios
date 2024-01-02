//
//  TutorialViewController.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import UIKit

class TutorialViewController: UIViewController {
	// MARK: Private Properties

	private var tutorialView: TutorialView!
	private var watchedTutorial: () -> Void

	// MARK: Initializers

	init(completion: @escaping () -> Void) {
		self.watchedTutorial = completion
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
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	// MARK: - Private Methods

	private func setupView() {
		tutorialView = TutorialView(tutorialVM: .init(completion: watchedTutorial))
		view = tutorialView
	}
}

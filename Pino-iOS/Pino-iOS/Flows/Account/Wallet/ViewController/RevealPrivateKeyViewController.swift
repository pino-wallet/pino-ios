//
//  RevealPrivateKeyViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/13/23.
//

import UIKit

class RevealPrivateKeyViewController: UIViewController {
	// MARK: Private Properties

	private var revealPrivateKeyView: RevealPrivateKeyView!
	private let revealPrivateKeyVM: RevealPrivateKeyViewModel!
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
		setupNotifications()
	}

	// MARK: - Initializers

	init(revealPrivateKeyVM: RevealPrivateKeyViewModel!) {
		self.revealPrivateKeyVM = revealPrivateKeyVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		NotificationCenter.default.removeObserver(UIApplication.userDidTakeScreenshotNotification)
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent, transitionCoordinator?.isInteractive == false {
            // code here
            HapticManager().run(type: .lightImpact)
        }
    }

	// MARK: - Private Methods

	private func setupView() {
		revealPrivateKeyView = RevealPrivateKeyView(
			revealPrivateKeyVM: revealPrivateKeyVM,
			copyPrivateKeyTapped: {
				self.copyPrivateKey()
			},
			doneButtonTapped: {
				self.dismissPage()
			},
			revealTapped: {
				self.showFaceID()
			}
		)
		view = revealPrivateKeyView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Your private key")
	}

	private func setupNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(screenshotTaken),
			name: UIApplication.userDidTakeScreenshotNotification,
			object: nil
		)
	}

	@objc
	private func screenshotTaken() {
		let screenshotAlertController = AlertHelper.alertController(
			title: revealPrivateKeyVM.screenshotAlertTitle,
			message: revealPrivateKeyVM.screenshotAlertMessage,
			actions: [.gotIt()]
		)
		present(screenshotAlertController, animated: true)
	}

	private func copyPrivateKey() {
		let pasteboard = UIPasteboard.general
		do {
			pasteboard.string = try revealPrivateKeyVM.privateKey()
			Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
		} catch {
			Toast.default(title: "Failed to fetch private key", style: .error).show(haptic: .warning)
		}
	}

	private func dismissPage() {
		navigationController?.popViewController(animated: true)
	}

	private func showFaceID() {
		authManager.unlockApp {
			self.revealPrivateKeyView.showPrivateKey()
		} onFailure: {
			#warning("Error should be handled")
		}
	}
}

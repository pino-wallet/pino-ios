//
//  LockScreenViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 3/7/24.
//

import UIKit

class LockScreenViewController: UIViewController {
    // MARK: - Typealiases
    typealias OnSuccessLoginClosureType = () -> Void
    // MARK: - Closures
    private var onSuccessLoginClosure: OnSuccessLoginClosureType
    // MARK: - Private Properties
    private var authVC: AuthenticationLockManager!
    private var privacyLockView = PrivacyLockView()
    private var shouldUnlockApp: Bool

    // MARK: - View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        setupView()
        setupStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        openFaceID()
    }
    
    // MARK: - Initializers
    init(onSuccessLoginClosure: @escaping OnSuccessLoginClosureType, shouldUnlockApp: Bool) {
        self.onSuccessLoginClosure = onSuccessLoginClosure
        self.shouldUnlockApp = shouldUnlockApp
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        authVC = AuthenticationLockManager(parentController: self)
        let openFaceIDTapGesture = UITapGestureRecognizer(target: self, action: #selector(openFaceID))
        privacyLockView.addGestureRecognizer(openFaceIDTapGesture)
        privacyLockView.isUserInteractionEnabled = true
        view = privacyLockView
    }
    
    private func setupStyles() {
        modalPresentationStyle = .fullScreen
    }
    
    @objc private func openFaceID() {
        if shouldUnlockApp {
            authVC.unlockApp {
                self.onSuccessLoginClosure()
            } onFailure: {
                // nothing to do here
            }
        }
    }
    
    // MARK: - Public Methods
    public func dismissSelf() {
        dismiss(animated: false)
    }

   

}

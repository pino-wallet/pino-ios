//
//  EnterInviteCodeViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/30/23.
//

import UIKit

class EnterInviteCodeViewController: UIViewController {
    
    // MARK: - Private Properties
    private let enterInviteCodeVM = EnterInviteCodeViewModel()
    private var enterInviteCodeView: EnterInviteCodeView!
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        enterInviteCodeView = EnterInviteCodeView(enterInviteCodeVM: enterInviteCodeVM, dismissViewClosure: {
            self.dismissSelf()
        })
        
        view = enterInviteCodeView
    }
    
    private func dismissSelf() {
        dismiss(animated: true)
    }

}

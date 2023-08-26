//
//  ApproveContractView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Combine
import Foundation
import UIKit

class ApproveContractView: UIView {
	// MARK: Private Properties

    private var approveContractVM: ApproveContractViewModel!
    private var approveBtn = PinoButton(style: .active)
    private let approveBtnTappedHandler: () -> Void
    private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	init(approveContractVM: ApproveContractViewModel, approveBtnTapped: @escaping () -> Void) {
        self.approveContractVM = approveContractVM
        self.approveBtnTappedHandler = approveBtnTapped
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
        addSubview(approveBtn)
        
        let approveTappedGesture = UITapGestureRecognizer(target: self, action: #selector(approveBtnTapped))
        approveBtn.addGestureRecognizer(approveTappedGesture)
    }

	private func setupStyle() {
        backgroundColor = .Pino.background
        
        approveBtn.title = "Approve"
    }

	private func setupContstraint() {
        approveBtn.pin(
            .horizontalEdges(padding: 16),
            .bottom(padding: 32)
        )
    }

	private func setupBindings() {}
    
    @objc
    private func approveBtnTapped() {
        approveContractVM.approveTokenUsageToPermit {
            // Approve req sent to network successfully 
            self.approveBtnTappedHandler()
        }
    }
}

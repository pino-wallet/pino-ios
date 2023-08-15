//
//  ApproveContractView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/15/23.
//

import Foundation
import Combine
import UIKit

class ApproveContractView: UIView {
    // MARK: Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    
    init(approveContractVM: ApproveContractViewModel) {
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
            
    }
    
    private func setupStyle() {
        
    }
    
    private func setupContstraint() {
        
    }
    
    private func setupBindings() {
        
    }
}


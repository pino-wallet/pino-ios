//
//  ActivityEmptyStateView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/10/23.
//

import UIKit

class ActivityEmptyStateView: UIView {
   // MARK: - Private Properties
    private let mainStackView = UIStackView()
    private let titleImageView = UIImageView()
    private let titleTextLabel = PinoLabel(style: .description, text: "")
    private var activityVM: ActivityViewModel!
    
    // MARK: - Initializers
    init(activityVM: ActivityViewModel) {
        self.activityVM = activityVM
        super.init(frame: .zero)
        
        
        setupView()
        setupStyles()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        mainStackView.addArrangedSubview(titleImageView)
        mainStackView.addArrangedSubview(titleTextLabel)
        
        addSubview(mainStackView)
    }
    
    private func setupStyles() {
        backgroundColor = .Pino.background
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 18
        mainStackView.alignment = .center
        
        titleTextLabel.font = .PinoStyle.mediumBody
        titleTextLabel.text = activityVM.noActivityMessage
        
        titleImageView.image = UIImage(named: activityVM.noActivityIconName)
    }
    
    private func setupConstraints() {
        mainStackView.pin(.centerY, .horizontalEdges(padding: 16))
        titleImageView.pin(.fixedHeight(72), .fixedWidth(72))
    }
}

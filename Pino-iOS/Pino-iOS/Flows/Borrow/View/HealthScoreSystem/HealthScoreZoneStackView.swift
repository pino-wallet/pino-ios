//
//  HealthScoreZoneStackView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/9/23.
//
import UIKit

class HealthScoreZoneStackView: UIStackView {
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)

        setupStyles()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    private func setupStyles() {
        axis = .horizontal
        spacing = 4
        alignment = .center
    }
}

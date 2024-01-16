//
//  EllipsisAnimatedText.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/15/24.
//

import Foundation
import UIKit

class EllipsisAnimatedText: UIView {
    // MARK: - Public Properties
    public let label = UILabel()
    // MARK: - Private Properties
    private let labelEllipsisTexts = [".", "..", "..."]
    private var defaultText: String
    private var currentState = 0
    private var timer: Timer?
    
    // MARK: - View Overrides
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            stop()
        }
    }
    
    // MARK: - Initializers
    init(defaultText: String) {
        self.defaultText = defaultText
        
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
       addSubview(label)
    }
    
    private func setupStyles() {
        label.text = defaultText
    }
    
    private func setupConstraints() {
        label.pin(.allEdges(padding: 0))
    }
    
    @objc private func updateLabel() {
        currentState = (currentState + 1) % labelEllipsisTexts.count
        label.text = "\(defaultText)\(labelEllipsisTexts[currentState])"
        
    }
    
    // MARK: - Public Methods
    
    public func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateLabel), userInfo: self, repeats: true)
            timer?.fire()
        }
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
}

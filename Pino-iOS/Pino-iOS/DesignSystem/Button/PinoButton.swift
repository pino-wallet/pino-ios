//
//  PinoButton.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public class PinoButton: UIButton {
    
    // MARK: - Public properties

    public var title: String {
        didSet {
            updateTitle()
        }
    }
    
    public var style: Style {
        didSet {
            updateStyle()
        }
    }
    
    // MARK: - Private properties

    private var loadingView = UIActivityIndicatorView()
    
    // MARK: - Initializers

    public init(style: Style, title: String = "") {
        self.title = title
        self.style = style
        super.init(frame: .zero)
        setupLoading()
        updateStyle()
        updateTitle()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Private methods

    private func updateStyle() {
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        layer.borderColor = style.borderColor?.cgColor
        layer.borderWidth = 1.2
        clipsToBounds = true
        if style == .loading {
            setTitle("", for: .normal)
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    private func updateTitle() {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.PinoStyle.semiboldTitle2
    }
    
    private func setupLoading() {
        loadingView.color = UIColor.white
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - UIButton overrides

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

}

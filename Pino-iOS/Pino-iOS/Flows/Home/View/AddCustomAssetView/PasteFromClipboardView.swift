//
//  PasteFromClipboardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/3/23.
//

import UIKit

class PasteFromClipboardView: UIView {
    public var contractAddress: String
    
    private let stackView = UIStackView()
    private let pasteButton = UIButton()
    private let contractAddressLabel = PinoLabel(style: PinoLabel.Style(textColor: .Pino.label, font: UIFont.PinoStyle.mediumSubheadline, numberOfLine: 0, lineSpacing: 6), text: "")
    private let pasteButtonIcon = UIImage(named: "copy")
    
    
    init(contractAddress: String) {
        self.contractAddress = contractAddress
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = .Pino.secondaryBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor.Pino.gray5.cgColor
        layer.cornerRadius = 8
        
        pasteButton.configuration = UIButton.Configuration.borderless()
        let attributedPastebuttonLabel = AttributedString("Paste from clipboard", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.PinoStyle.semiboldSubheadline!, NSAttributedString.Key.foregroundColor: UIColor.Pino.green3]))
        pasteButton.configuration?.attributedTitle = attributedPastebuttonLabel
        pasteButton.configuration?.image = UIImage(named: "copy")
        pasteButton.configuration?.imagePadding = 4
        pasteButton.contentHorizontalAlignment = .left
        var pasteButtonContentInset = NSDirectionalEdgeInsets()
        pasteButtonContentInset.leading = 0
        pasteButton.configuration?.contentInsets = pasteButtonContentInset
        
        
        contractAddressLabel.text = contractAddress
        contractAddressLabel.font = UIFont.PinoStyle.mediumSubheadline
        contractAddressLabel.lineBreakMode = .byWordWrapping
        
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.addArrangedSubview(pasteButton)
        stackView.addArrangedSubview(contractAddressLabel)
        stackView.spacing = 6
    }
    
    private func setupConstraints() {
        stackView.pin(.verticalEdges(to: superview, padding: 12), .horizontalEdges(to: superview, padding: 14))
        pasteButton.pin(.top(to: stackView, padding: 0), .fixedHeight(22), .leading(to: stackView, padding: 0))
    }
}

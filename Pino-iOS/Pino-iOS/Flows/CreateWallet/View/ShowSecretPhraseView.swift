//
//  ShowSecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

class ShowSecretPhraseView: UIView {
    
    // MARK: Private Properties
    
    private let contentStackView = UIStackView()
    private let titleStackView = UIStackView()
    private let pageTitle = UILabel()
    private let pageDescription = UILabel()
    private let seedPhraseStackView = UIStackView()
    private let seedPhraseCollectionView = SecretPhraseCollectionView()
    private let shareButton = UIButton()
    private let continueStackView = UIStackView()
    private let saveSecretPhareStackView = UIStackView()
    private let savedCheckBox = PinoCheckBox()
    private var checkBoxDescription = UILabel()
    private let continueButton = PinoButton(style: .deactive, title: "Continue")
        
    private var shareSecretPhrase: (() -> Void)
        
    // MARK: Initializers
	
    init(_ secretPhrase: [SeedPhrase], shareSecretPhare: @escaping (() -> Void)) {
        self.shareSecretPhrase = shareSecretPhare
		super.init(frame: .zero)
        
        seedPhraseCollectionView.seedPhrase = secretPhrase
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
    
    private func activateContinueButton(_ isActive: Bool) {
        if isActive {
            self.continueButton.style = .active
        } else {
            self.continueButton.style = .deactive
        }
    }
}

extension ShowSecretPhraseView {
    
    // MARK: UI Methods
    
    private func setupView() {
        contentStackView.addArrangedSubview(titleStackView)
        contentStackView.addArrangedSubview(seedPhraseStackView)
        titleStackView.addArrangedSubview(pageTitle)
        titleStackView.addArrangedSubview(pageDescription)
        seedPhraseStackView.addArrangedSubview(seedPhraseCollectionView)
        seedPhraseStackView.addArrangedSubview(shareButton)
        continueStackView.addArrangedSubview(saveSecretPhareStackView)
        continueStackView.addArrangedSubview(continueButton)
        saveSecretPhareStackView.addArrangedSubview(savedCheckBox)
        saveSecretPhareStackView.addArrangedSubview(checkBoxDescription)
        addSubview(contentStackView)
        addSubview(continueStackView)
        
        shareButton.addAction(UIAction(handler: { _ in
            self.shareSecretPhrase()
        }), for: .touchUpInside)
        
        savedCheckBox.addAction(UIAction(handler: { _ in
            self.activateContinueButton(self.savedCheckBox.isChecked)
        }), for: .touchUpInside)
    }
    
    private func setupStyle() {
        backgroundColor = .Pino.background
        
        pageTitle.text = "Backup seed pharase"
        pageTitle.textColor = .Pino.label
        pageTitle.font = .PinoStyle.semiboldTitle2
        
        pageDescription.text = "A two line description should be here. A two line description should be here"
        pageDescription.textColor = .Pino.secondaryLabel
        pageDescription.font = .PinoStyle.mediumCallout
        pageDescription.numberOfLines = 0
        
        shareButton.setTitle("Copy", for: .normal)
        shareButton.setTitleColor(.Pino.label, for: .normal)
        shareButton.titleLabel?.font = .PinoStyle.semiboldBody
        
        checkBoxDescription.text = "I saved secret phrase"
        checkBoxDescription.textColor = .Pino.label
        checkBoxDescription.font = .PinoStyle.mediumCallout
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 32
        
        titleStackView.axis = .vertical
        titleStackView.spacing = 12
        
        seedPhraseStackView.axis = .vertical
        seedPhraseStackView.spacing = 40
        seedPhraseStackView.alignment = .center
        
        saveSecretPhareStackView.axis = .horizontal
        saveSecretPhareStackView.spacing = 6
        saveSecretPhareStackView.alignment = .center
        
        continueStackView.axis = .vertical
        continueStackView.spacing = 40
        continueStackView.alignment = .center
    }
    
    private func setupContstraint() {
        contentStackView.pin(
            .top(padding: 115),
            .leading(padding: 16),
            .trailing(padding: 16)
        )
        continueStackView.pin(
            .bottom(padding: 42),
            .leading(padding: 16),
            .trailing(padding: 16)
        )
        continueButton.pin(
            .width(to: continueStackView),
            .fixedHeight(56)
        )
        seedPhraseCollectionView.pin(
            .trailing(to: seedPhraseStackView),
            .leading(to: seedPhraseStackView)
        )
    }
}

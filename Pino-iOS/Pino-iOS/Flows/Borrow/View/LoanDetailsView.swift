//
//  LoanDetailsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import UIKit

class LoanDetailsView: UIView {
    // MARK: - Private Properties
    private let mainStackView = UIStackView()
    private let headerContainerView = PinoContainerCard()
    private let headerStackView = UIStackView()
    private let headerTitleImage = UIImageView()
    private let headerTitleLabel = PinoLabel(style: .title, text: "")
    private let contentContainerView = PinoContainerCard()
    private let contentStackView = UIStackView()
    private let borderView = UIView()
    private let buttonsStackView = UIStackView()
    private let increaseButton = PinoButton(style: .active)
    private let withdrawButton = PinoButton(style: .secondary)
    private var apyStackView: LoanDetailsInfoStackView!
    private var borrowedAmountStackView: LoanDetailsInfoStackView!
    private var accruedFeeStackView: LoanDetailsInfoStackView!
    private var totalDebtStackView: LoanDetailsInfoStackView!
    
    
    private var loanDetailsVM: LoanDetailsViewModel
    
    // MARK: - Initializers
    init(loanDetailsVM: LoanDetailsViewModel) {
        self.loanDetailsVM = loanDetailsVM
        
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
        apyStackView = LoanDetailsInfoStackView(titleText: loanDetailsVM.apyTitle, infoText: loanDetailsVM.apy)
        borrowedAmountStackView = LoanDetailsInfoStackView(titleText: loanDetailsVM.borrowedAmountTitle, infoText: loanDetailsVM.borrowedAmount)
        accruedFeeStackView = LoanDetailsInfoStackView(titleText: loanDetailsVM.accruedFeeTitle, infoText: loanDetailsVM.accruedFee)
        totalDebtStackView = LoanDetailsInfoStackView(titleText: loanDetailsVM.totalDebtTitle, infoText: loanDetailsVM.totalDebt)
        
        contentContainerView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(apyStackView)
        contentStackView.addArrangedSubview(borrowedAmountStackView)
        contentStackView.addArrangedSubview(accruedFeeStackView)
        contentStackView.addArrangedSubview(borderView)
        contentStackView.addArrangedSubview(totalDebtStackView)
        
        headerStackView.addArrangedSubview(headerTitleImage)
        headerStackView.addArrangedSubview(headerTitleLabel)
        
        headerContainerView.addSubview(headerStackView)
        
        mainStackView.addArrangedSubview(headerContainerView)
        mainStackView.addArrangedSubview(contentContainerView)
        
        buttonsStackView.addArrangedSubview(increaseButton)
        buttonsStackView.addArrangedSubview(withdrawButton)
        
        addSubview(mainStackView)
        addSubview(buttonsStackView)
    }
    
    private func setupStyles() {
        backgroundColor = .Pino.background
        
        apyStackView.infoLabel.textColor = .Pino.green
        
        totalDebtStackView.titleLabel.textColor = .Pino.label
        
        totalDebtStackView.infoLabel.font = .PinoStyle.semiboldBody
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        headerStackView.axis = .vertical
        headerStackView.spacing = 16
        headerStackView.alignment = .center
        
        headerTitleImage.image = UIImage(named: loanDetailsVM.tokenIcon)
        
        headerTitleLabel.font = .PinoStyle.semiboldTitle2
        headerTitleLabel.text = loanDetailsVM.tokenBorrowAmountAndSymbol
        headerTitleLabel.numberOfLines = 0
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        increaseButton.title = loanDetailsVM.increaseLoanTitle
        
        withdrawButton.title = loanDetailsVM.withdrawTitle
        
        borderView.backgroundColor = .Pino.gray5
        
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 24
        
    }
    
    private func setupConstraints() {
        headerTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        
        mainStackView.pin(.top(to: layoutMarginsGuide, padding: 24), .horizontalEdges(to: layoutMarginsGuide, padding: 0))
        headerStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 16))
        headerTitleImage.pin(.fixedWidth(50), .fixedHeight(50))
        borderView.pin(.fixedHeight(1))
        contentStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 18))
        buttonsStackView.pin(.horizontalEdges(to: layoutMarginsGuide, padding: 0), .bottom(to: layoutMarginsGuide, padding: 20))
    }
}

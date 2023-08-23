//
//  InvestmentRiskPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import Foundation

struct InvestmentRiskPerformanceViewModel {
    // MARK: - Private Properties
    
    private let selectedAsset: InvestableAssetViewModel
    
    // MARK: - Public Properties

    public let protocolTitle = "Protocol"
    public let investmentRiskTitle = "Benefits and risks"
    public let confirmButtonTitle = "Got it"
    public let risksInfo: [(titel: String, color: String)] = [
        ("Higher fee collection", "Green Color"),
        ("Principal value volatility", "Orange Color"),
        ("Impermanent loss", "Orange Color")
    ]
    
    public var assetImage: URL {
        selectedAsset.assetImage
    }
    public var assetName: String {
        selectedAsset.assetName
    }
    public var protocolImage: String {
        selectedAsset.assetProtocol.protocolInfo.image
    }
    public var protocolName: String {
        selectedAsset.assetProtocol.protocolInfo.name
    }
    public var protocolDescription: String {
        "\(protocolName) is a DEX enabling users to supply liquidity and earn trade fees in return."
    }
    public var investmentRisk: InvestmentRisk {
        selectedAsset.investmentRisk
    }
    public var investmentRiskName: String {
        investmentRisk.title
    }
    
    // MARK: - Initializers
    
    init(selectedAsset: InvestableAssetViewModel) {
        self.selectedAsset = selectedAsset
    }
}

//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//

struct AboutCoinViewModel {
	// MARK: - Public Properties

	public let aboutCoin: AboutCoinModel!

	public var website: (key: String, value: String) {
		(key: "Website", value: aboutCoin.website)
	}

	public var marketCap: (key: String, value: String) {
        (key: "Market Cap", value: aboutCoin.marketCap.currencyFormatting)
	}

	public var Valume: (key: String, value: String) {
		(key: "Valume (24h)", value: aboutCoin.valume)
	}

	public var circulatingSupply: (key: String, value: String) {
		(key: "Circulating supply", value: aboutCoin.circulatingSupply)
	}

	public var totalSuply: (key: String, value: String) {
		(key: "Total supply", value: aboutCoin.totalSuply)
	}

	public var explorerURL: String {
		aboutCoin.explorerURL
	}
}

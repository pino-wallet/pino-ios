//
//  CoinInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/9/23.
//

import Foundation

struct CoinInfoViewModel {
	// MARK: - Public Properties

	public var coinInfoModel: CoinInfoModel!

	public var assetImage: String {
		coinInfoModel.assetImage
	}

	public var userAmount: String {
		if let userAmount = coinInfoModel.userAmount {
			return"$\(userAmount)"
		} else {
            fatalError()
		}
	}

	public var coinAmount: String {
		if let coinAmount = coinInfoModel.coinAmount {
			return"$\(coinAmount)"
		} else {
			fatalError()
		}
	}

	public var name: String {
		coinInfoModel.name
	}

	public var volatilityRate: String {
		coinInfoModel.volatilityRate
	}

	public var investAmount: String {
		if let investAmount = coinInfoModel.investAmount {
			return "\(investAmount) \(name)"
		} else {
			return "0\(name)"
		}
	}

	public var callateralAmount: String {
		if let collateralAmount = coinInfoModel.collateralAmount {
			return "\(collateralAmount) \(name)"
		} else {
			return "0\(name)"
		}
	}

	public var borrowAmount: String {
		if let borrowAmount = coinInfoModel.barrowAmount {
			return "\(borrowAmount) \(name)"
		} else {
			return "0\(name)"
		}
	}
}

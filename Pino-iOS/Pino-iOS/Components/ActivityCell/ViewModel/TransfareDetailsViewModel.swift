//
//  TransfareDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

import Foundation

struct TransfareDetailsViewModel: ActivityDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityModel
	internal var globalAssetsList: [AssetViewModel]

	// MARK: - Private Properties

	private var transfareToken: AssetViewModel? {
		globalAssetsList.first(where: { $0.id == activityModel.detail?.tokenID })
	}

	private var transfareTokenDecimal: Int {
		transfareToken?.decimal ?? 0
	}

	// MARK: - Public Properties

	public var transfareTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail?.amount ?? "", decimal: transfareTokenDecimal)
	}

	public var transfareTokenSymbol: String {
		transfareToken?.symbol ?? ""
	}
    
    public var transfareTokenImage: URL? {
        transfareToken?.image
    }
    
    public var transfareFromAddress: String {
        activityModel.fromAddress.shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
    }
    
    public var transfareToAddress: String {
        activityModel.toAddress.shortenedString(characterCountFromStart: 6, characterCountFromEnd: 4)
    }
}

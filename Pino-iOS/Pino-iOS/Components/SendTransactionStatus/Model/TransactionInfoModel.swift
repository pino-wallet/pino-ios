//
//  TransactionInfo.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/21/23.
//

import Foundation

struct TransactionInfoModel {
	var transactionType: SendTransactionType
	var transactionDex: DexSystemModel
	var transactionAmount: String
	var transactionToken: AssetViewModel
}

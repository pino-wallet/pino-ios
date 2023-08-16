//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import PromiseKit

struct ApproveContractViewModel {
    
    // MARK: - Public Properties

    // MARK: - Private Properties
    private var web3 = Web3Core.shared
    private var pinoWalletManager = PinoWalletManager()
   
    // MARK: - Public Methods
    public func allowPinoProxyContract() throws {
        
        firstly {
            try web3.getAllowanceOf(contractAddress: "Uni Contract Address", spenderAddress: "Para Swap", ownerAddress: Web3Core.Constants.pinoProxyAddress)
        }.done { allowanceAmount in
            if allowanceAmount == 0 || allowanceAmount < trxAmount {
                // NOT ALLOWED -> SHOW APPROVE PAGE
                
            } else {
                // ALLOWED -> SHOW CONFIRM PAGE
            }
        }.catch { error in
            print(error)
        }
    }
}

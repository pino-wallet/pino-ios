//
//  AboutCoinViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import Combine
import PromiseKit
import Web3
import Web3_Utility

class ApproveContractViewModel {
	// MARK: - Public Properties

	// MARK: - Private Properties

	private var web3 = Web3Core.shared
	private var pinoWalletManager = PinoWalletManager()
	private let paraSwapAPIClient = ParaSwapAPIClient()
	private let oneInchAPIClient = OneInchAPIClient()
	private let zeroXAPIClient = ZeroXAPIClient()
    private var swapConfirmVM: SwapConfirmationViewModel!
	private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers
    public init(swapConfirmVM: SwapConfirmationViewModel) {
        self.swapConfirmVM = swapConfirmVM
    }

    private var destTokenID: String {
        swapConfirmVM.toToken.selectedToken.id
    }
    
    private var destTokenAmount: BigUInt {
//        return try! BigUInt(UInt64.max.description)
        Utilities.parseToBigUInt(swapConfirmVM.toToken.tokenAmount!, decimals: swapConfirmVM.toToken.selectedToken.decimal)!
    }
    
	// MARK: - Public Methods
    
    public func approveTokenUsageToPermit(completion: @escaping () -> Void) {
        web3.approveContract(address: destTokenID, amount: destTokenAmount, spender: Web3Core.Constants.permitAddress).done { trxHash in
            print("APPROVE TRX HASH: \(trxHash)")
            completion()
        }.catch { error in
            print("Failed to give permission")
            Toast.default(title: "Failed to Approve", style: .error).show(haptic: .warning)
        }
    }

}

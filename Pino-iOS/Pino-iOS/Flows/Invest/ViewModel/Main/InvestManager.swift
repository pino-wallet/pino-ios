//
//  InvestManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 10/9/23.
//
import BigInt
import Foundation
import PromiseKit
import Combine
import Web3_Utility
import Web3

class InvestManager: Web3ManagerProtocol {
	// MARK: - Private Properties
    
	private var investProtocol: InvestProtocolViewModel
	private var investAmount: String
    private let selectedToken: AssetViewModel
    private let nonce = BigNumber.bigRandomeNumber
    private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
    private let web3Client = Web3APIClient()
    private var cancellables = Set<AnyCancellable>()
	private var wethToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
	}
    private var tokenUIntNumber: BigUInt {
        Utilities.parseToBigUInt(investAmount, decimals: selectedToken.decimal)!
    }
    // MARK: - Internal properties
    
    internal var web3 = Web3Core.shared
    internal var walletManager = PinoWalletManager()
    
    // MARK: Initializers

    init(selectedToken: AssetViewModel, investProtocol: InvestProtocolViewModel, investAmount: String) {
        self.selectedToken = selectedToken
		self.investProtocol = investProtocol
		self.investAmount = investAmount
	}

	// MARK: Public Methods

	public func invest() {
		switch investProtocol {
        case .maker:
            investInDai()
		case .compound:
			investInCompound()
        case .aave:
            break
        case .balancer:
            break
        case .uniswap:
            break
		}
	}

	// MARK: - Private Methods

	private func investInDai() {
        firstly {
            fetchHash()
        }.then { plainHash in
            self.signHash(plainHash: plainHash)
        }.then { signiture -> Promise<(String, String?)> in
            // Check allowance of protocol
            let spenderAddress = Web3Core.Constants.sDaiContractAddress
            return self.checkAllowanceOfProvider(
                approvingToken: self.selectedToken,
                approvingAmount: self.investAmount,
                spenderAddress: spenderAddress
            ).map { (signiture, $0) }
        }.then { signiture, allowanceData -> Promise<(String, String?)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
            self.web3.getDaiToSDaiCallData(
                amount: tokenUIntNumber,
                recipientAdd: walletManager.currentAccount.eip55Address
            ).map { ($0, permitData, allowanceData) }
        }.then { protocolCallData, permitData, allowanceData in
            // MultiCall
            var callDatas = [permitData, protocolCallData]
            if let allowanceData { callDatas.insert(allowanceData, at: 0) }
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
	}

	private func withdrawDai() {
        firstly {
            fetchHash()
        }.then { plainHash in
            self.signHash(plainHash: plainHash)
        }.then { signiture -> Promise<(String)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture)
        }.then { [self] permitData -> Promise<(String, String)> in
            self.web3.getSDaiToDaiCallData(
                amount: tokenUIntNumber,
                recipientAdd: walletManager.currentAccount.eip55Address
            ).map { ($0, permitData) }
        }.then { protocolCallData, permitData in
            // MultiCall
            var callDatas = [permitData, protocolCallData]
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
	}
    
    private func investInCompound() {
        if selectedToken.isEth {
            compoundETHDeposit()
        } else if selectedToken.isWEth{
            compoundWETHDeposit()
        } else {
            compoundDeposit()
        }
    }
    
    private func compoundDeposit() {
        let cTokenID = Web3Core.TokenID(id: self.selectedToken.id).cTokenID
        firstly {
            fetchHash()
        }.then { plainHash in
            self.signHash(plainHash: plainHash)
        }.then { signiture -> Promise<(String, String?)> in
            // Check allowance of protocol
            self.checkAllowanceOfProvider(
                approvingToken: self.selectedToken,
                approvingAmount: self.investAmount,
                spenderAddress: cTokenID
            ).map { (signiture, $0) }
        }.then { signiture, allowanceData -> Promise<(String, String?)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
            self.web3.getDepositV2CallData(
                tokenAdd: cTokenID,
                amount: tokenUIntNumber,
                recipientAdd: walletManager.currentAccount.eip55Address
            ).map { ($0, permitData, allowanceData) }
        }.then { protocolCallData, permitData, allowanceData in
            // MultiCall
            var callDatas = [permitData, protocolCallData]
            if let allowanceData { callDatas.insert(allowanceData, at: 0) }
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func compoundETHDeposit() {
        let proxyFee = 0.bigNumber.bigUInt
        firstly {
            self.web3.getDepositETHV2CallData(
                recipientAdd: walletManager.currentAccount.eip55Address,
                proxyFee: proxyFee
            )
        }.then { protocolCallData in
            // MultiCall
            var callDatas = [protocolCallData]
            let ethDepositAmount = self.tokenUIntNumber + proxyFee
            return self.callProxyMultiCall(data: callDatas, value: ethDepositAmount)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func compoundWETHDeposit() {
        firstly {
            fetchHash()
        }.then { plainHash in
            self.signHash(plainHash: plainHash)
        }.then { signiture -> Promise<(String)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture)
        }.then { [self] permitData -> Promise<(String, String)> in
            self.web3.getDepositWETHV2CallData(
                amount: tokenUIntNumber,
                recipientAdd: walletManager.currentAccount.eip55Address
            ).map { ($0, permitData) }
        }.then { protocolCallData, permitData in
            // MultiCall
            var callDatas = [permitData, protocolCallData]
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func compoundWithdraw() {
        let cTokenID = Web3Core.TokenID(id: self.selectedToken.id).cTokenID
        firstly {
            fetchHash()
        }.then { plainHash in
            self.signHash(plainHash: plainHash)
        }.then { signiture in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture)
        }.then { [self] permitData in
            self.web3.getWithdrawV2CallData(
                tokenAdd: cTokenID,
                amount: tokenUIntNumber,
                recipientAdd: walletManager.currentAccount.eip55Address
            ).map { ($0, permitData) }
        }.then { protocolCallData, permitData in
            // MultiCall
            var callDatas = [permitData, protocolCallData]
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func compoundETHWithdraw() {
        let proxyFee = 0.bigNumber.bigUInt
        firstly {
            self.web3.getWithdrawETHV2CallData(
                recipientAdd: walletManager.currentAccount.eip55Address,
                amount: tokenUIntNumber
            )
        }.then { protocolCallData in
            // MultiCall
            var callDatas = [protocolCallData]
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func compoundWETHWithdraw() {
        firstly {
            fetchHash()
        }.then { plainHash in
            self.signHash(plainHash: plainHash)
        }.then { signiture -> Promise<(String)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture)
        }.then { [self] permitData -> Promise<(String, String)> in
            self.web3.getWithdrawWETHV2CallData(
                amount: tokenUIntNumber,
                recipientAdd: walletManager.currentAccount.eip55Address
            ).map { ($0, permitData) }
        }.then { protocolCallData, permitData in
            // MultiCall
            var callDatas = [permitData, protocolCallData]
            return self.callProxyMultiCall(data: callDatas, value: nil)
        }.done { trxHash in
            print(trxHash)
        }.catch { error in
            print(error.localizedDescription)
        }
    }


    private func fetchHash() -> Promise<String> {
        Promise<String> { seal in

            let hashREq = EIP712HashRequestModel(
                tokenAdd: selectedToken.id,
                amount: investAmount,
                spender: Web3Core.Constants.pinoProxyAddress,
                nonce: nonce.description,
                deadline: deadline.description
            )

            web3Client.getHashTypedData(eip712HashReqInfo: hashREq).sink { completed in
                switch completed {
                case .finished:
                    print("Info received successfully")
                case let .failure(error):
                    print(error)
                }
            } receiveValue: { hashResponse in
                seal.fulfill(hashResponse.hash)
            }.store(in: &cancellables)
        }
    }
    
    private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
        web3.callProxyMulticall(data: data, value: value ?? 0.bigNumber.bigUInt)
    }
    
    // MARK: Internal Methods
    
    internal func getProxyPermitTransferData(signiture: String) -> Promise<String> {
        return web3.getPermitTransferCallData(
            amount: tokenUIntNumber,
            tokenAdd: selectedToken.id,
            signiture: signiture,
            nonce: nonce,
            deadline: deadline
        )
    }
}

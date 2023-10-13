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

class InvestManager {
	// MARK: - Private Properties

	private var web3 = Web3Core.shared
	private var investProtocol: InvestProtocolViewModel
	private var investAmount: String
	private var walletManager = PinoWalletManager()
    private let selectedToken: AssetViewModel
    private let nonce = BigNumber.bigRandomeNumber
    private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
    private let web3Client = Web3APIClient()
    private var cancellables = Set<AnyCancellable>()
	private var wethToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
	}

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
            // Sign hash
            self.signHash()
        }.then { signiture -> Promise<(String, String?)> in
            // Check allowance of protocol
            let spenderAddress = Web3Core.Constants.sDaiContractAddress
            return self.checkAllowanceOfProtocol(spenderAddress: spenderAddress).map { (signiture, $0) }
        }.then { signiture, allowanceData -> Promise<(String, String?)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
            self.web3.getDaiToSDaiCallData(
                amount: investAmount.bigUInt!,
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
            // Sign hash
            self.signHash()
        }.then { signiture -> Promise<(String)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture)
        }.then { [self] permitData -> Promise<(String, String)> in
            self.web3.getSDaiToDaiCallData(
                amount: investAmount.bigUInt!,
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
            // Sign hash
            self.signHash()
        }.then { signiture -> Promise<(String, String?)> in
            // Check allowance of protocol
            self.checkAllowanceOfProtocol(spenderAddress: cTokenID).map { (signiture, $0) }
        }.then { signiture, allowanceData -> Promise<(String, String?)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
        }.then { [self] permitData, allowanceData -> Promise<(String, String, String?)> in
            self.web3.getDepositV2CallData(
                tokenAdd: cTokenID,
                amount: investAmount.bigUInt!,
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
        firstly {
            self.web3.getDepositETHV2CallData(
                recipientAdd: walletManager.currentAccount.eip55Address,
                proxyFee: 0.bigNumber.bigUInt
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
    
    private func compoundWETHDeposit() {
        firstly {
            // Sign hash
            self.signHash()
        }.then { signiture -> Promise<(String)> in
            // Permit Transform
            self.getProxyPermitTransferData(signiture: signiture)
        }.then { [self] permitData -> Promise<(String, String)> in
            self.web3.getDepositWETHV2CallData(
                amount: investAmount.bigUInt!,
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
    
    private func signHash() -> Promise<String> {
        Promise<String> { seal in
            firstly {
                fetchHash()
            }.done { [self] hash in
                var signiture = try Sec256k1Encryptor.sign(
                    msg: hash.hexToBytes(),
                    seckey: walletManager.currentAccountPrivateKey.string.hexToBytes()
                )
                signiture[signiture.count - 1] += 27

                seal.fulfill("0x\(signiture.toHexString())")

            }.catch { error in
                fatalError(error.localizedDescription)
            }
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

    private func checkAllowanceOfProtocol(spenderAddress: String) -> Promise<String?> {
        return Promise<String?> { seal in
            firstly {
                try web3.getAllowanceOf(
                    contractAddress: selectedToken.id,
                    spenderAddress: spenderAddress,
                    ownerAddress: Web3Core.Constants.pinoProxyAddress
                )
            }.done { [self] allowanceAmount in
                let tokenDecimal = selectedToken.decimal
                let tokenAmount = Utilities.parseToBigUInt(investAmount, decimals: tokenDecimal)!
                if allowanceAmount == 0 || allowanceAmount < tokenAmount {
                    web3.getApproveProxyCallData(
                        tokenAdd: selectedToken.id,
                        spender: spenderAddress
                    ).done { approveCallData in
                        seal.fulfill(approveCallData)
                    }.catch { error in
                        seal.reject(error)
                    }
                } else {
                    // ALLOWED
                    seal.fulfill(nil)
                }
            }.catch { error in
                print(error)
            }
        }
    }

    private func getProxyPermitTransferData(signiture: String) -> Promise<String> {
        let tokenUIntNumber = Utilities.parseToBigUInt(investAmount, decimals: selectedToken.decimal)
        return web3.getPermitTransferCallData(
            amount: tokenUIntNumber!,
            tokenAdd: selectedToken.id,
            signiture: signiture,
            nonce: nonce,
            deadline: deadline
        )
    }
    
    private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
        web3.callProxyMulticall(data: data, value: value ?? 0.bigNumber.bigUInt)
    }
}

//
//  Web3ABI.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/14/23.
//

import Foundation

struct Web3ABI {
	public static var erc20AbiString = """
	[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]

	"""

	public static var testABI = """
	[
	  {
	    "inputs": [
	      {
	        "components": [
	          {
	            "internalType": "uint8",
	            "name": "a",
	            "type": "uint8"
	          },
	          {
	            "internalType": "uint8",
	            "name": "b",
	            "type": "uint8"
	          },
	          {
	            "internalType": "uint8",
	            "name": "c",
	            "type": "uint8"
	          },
	          {
	            "internalType": "uint8",
	            "name": "d",
	            "type": "uint8"
	          },
	          {
	            "internalType": "bool",
	            "name": "e",
	            "type": "bool"
	          },
	          {
	            "components": [
	              {
	                "components": [
	                  {
	                    "internalType": "address",
	                    "name": "token",
	                    "type": "address"
	                  },
	                  {
	                    "internalType": "uint256",
	                    "name": "amount",
	                    "type": "uint256"
	                  }
	                ],
	                "internalType": "struct TestTuple.TokenPermissions",
	                "name": "permitted",
	                "type": "tuple"
	              },
	              {
	                "internalType": "uint256",
	                "name": "nonce",
	                "type": "uint256"
	              },
	              {
	                "internalType": "uint256",
	                "name": "deadline",
	                "type": "uint256"
	              }
	            ],
	            "internalType": "struct TestTuple.PermitTransferFrom",
	            "name": "f",
	            "type": "tuple"
	          }
	        ],
	        "internalType": "struct TestTuple.Data",
	        "name": "d",
	        "type": "tuple"
	      }
	    ],
	    "name": "testTuple1",
	    "outputs": [
	      {
	        "internalType": "uint8",
	        "name": "",
	        "type": "uint8"
	      }
	    ],
	    "stateMutability": "payable",
	    "type": "function"
	  }
	]

	"""
}

public enum ABIMethodCall: String {
	case decimal = "decimals"
	case balance = "balanceOf"
	case name
	case symbol
	case allowance
	case approve
}

public enum ABIMethodWrite: String {
	case approve
	case transfer
	case permitTransferFrom
	case sweepToken
	case unwrapWETH9
	case wrapETH
	case multicall
	case testTuple1
}

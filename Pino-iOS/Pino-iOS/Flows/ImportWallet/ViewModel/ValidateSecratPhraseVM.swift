//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

class ValidateSecratPhrase {
    
    
    //this code is the firt one and works with notification
	private let secratPharse: [String]

	init(secratPharse: [String]) {
		self.secratPharse = secratPharse
	}

	func isContiansSeed() -> Bool {
		let intersction = Array(Set(secratPharse).intersection(HDWallet.englishWordList))
		if intersction.count == secratPharse.count {
			return true
		} else {
			return false
		}
	}
    
    
    //this is the code we think about it
    /*
        private let secratPharse: [String]
        private let messageText: (String) -> Void
    
    
        init(secratePharse: [String], messageText: @escaping(String) ->Void){
            self.secratPharse = secratePharse
            self.messageText = messageText
        }
    
        func isCountain(seedPharse: [String] ,result: @escaping((String)) ->Void) {
            let intersectionArray = Array(Set(seedPharse).intersection(HDWallet.englishWordList))
            if intersectionArray.count == seedPharse.count {
                result("success")
            }
            else{
                result("false")
            }
        }
    */
    
}

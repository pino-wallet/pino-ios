//
//  Sec256k1Encryption.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/8/23.
//

import secp256k1
import Foundation


struct Sec256k1Encryptor {
    
    // MARK: - Private Properties

    private enum SignatureError: Error {
        case invalidMsgLen
        case invalidKey
        case signFailed
    }

    // MARK: - Public Methods
    
    public static func sign(msg: [UInt8], seckey: [UInt8]) throws -> [UInt8] {
        // Check the lengths of msg and seckey
        guard msg.count == 32 else {
            throw SignatureError.invalidMsgLen
        }
        
        guard seckey.count == 32 else {
            throw SignatureError.invalidKey
        }
        
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
        
        // Verify the private key
        guard (secp256k1_ec_seckey_verify(context!, seckey) != 0) else {
            throw SignatureError.invalidKey
        }
        
        // Initialize variables
        var sig = secp256k1_ecdsa_recoverable_signature()
        let noncefunc: secp256k1_nonce_function? = secp256k1_nonce_function_rfc6979
        
        // Sign the message
        guard (secp256k1_ecdsa_sign_recoverable(context!, &sig, msg, seckey, noncefunc, nil) != 0) else {
            throw SignatureError.signFailed
        }
        
        // Serialize the signature
        var output = [UInt8](repeating: 0, count: 65)
        var recid: Int32 = 0
        
        secp256k1_ecdsa_recoverable_signature_serialize_compact(context!, &output, &recid, &sig)
        
        // Add back recid to get 65 bytes sig
        output[64] = UInt8(recid)
        return output
    }

    
}



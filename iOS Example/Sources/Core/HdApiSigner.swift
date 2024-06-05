//
//  HdApiSigner.swift
//  iOS Example
//
//  Created by CW Lee on 19/01/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import BitcoinCore
import curveSecp256k1
import HdWalletKit

public class HDApiSigner : ISigner {
    
    public var publicKey: Data
    // public key in compress format 
    var sckey: curveSecp256k1.SecretKey
    init(privateKey: Data) throws {
        self.sckey = try SecretKey(hex: privateKey.hexString)
        self.publicKey = Data(hex: try self.sckey.toPublic().serialize(compressed: true))
    }
    
    init() throws {
        self.sckey = curveSecp256k1.SecretKey()
        self.publicKey = Data(hex: try self.sckey.toPublic().serialize(compressed: true))
    }
    
    convenience init (text: String ) throws {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
//        if words > 1 {
////            try HDExtendedKey(seed: text, xpri)
//            try HDPrivateKey(seed: text, xPrivKey: 0)
//        }
        
        let extendedKey = try! HDExtendedKey(extendedKey: text )
        let key = extendedKey.serialized
        try self.init(privateKey: key)
    }
    
    public func sign(message: Data) -> Data {
        guard let sigs = try! Data(hexString: curveSecp256k1.ECDSA.signRecoverable(key: self.sckey, hash: message.hexString).serialize_der()
        ) else { return Data() }
        return sigs
    }
    
    public func schnorrSign(message: Data, publicKey: Data) -> Data {
        print (message)
        print (publicKey)
        return message
    }
    
}

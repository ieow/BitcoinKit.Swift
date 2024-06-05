//
//  MPCSigner.swift
//  iOS Example
//
//  Created by CW Lee on 18/01/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import BitcoinCore
import mpc_core_kit_swift
import curveSecp256k1

extension MpcCoreKit : ISigner {
    
    public var publicKey : Data {
        let pkey = self.getTssPubKey()
        return pkey
    }
    
    public func sign(message: Data) -> Data {
        let signature =  self.tssSign(message: message)
        let sigDer = try? Data(hex: Signature(hex: signature.hexString).serialize_der())
        return sigDer ?? Data()
    }
    
    public func schnorrSign(message: Data, publicKey: Data) -> Data {
        print (message)
        print (publicKey)
        return message
    }
}

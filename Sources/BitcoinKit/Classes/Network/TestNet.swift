import BitcoinCore
import Foundation
import CryptoSwift

class TestNet: INetwork {
    private static let testNetDiffDate = 1_329_264_000 // February 16th 2012

    let bundleName = "Bitcoin"

    let pubKeyHash: UInt8 = 0x6F
    let privateKey: UInt8 = 0xEF
    let scriptHash: UInt8 = 0xC4
    let bech32PrefixPattern: String = "tb"
    let xPubKey: UInt32 = 0x0435_87CF
    let xPrivKey: UInt32 = 0x0435_8394
    let magic: UInt32 = 0x0B11_0907
    let port = 18333
    let coinType: UInt32 = 1
    let sigHash: SigHashType = .bitcoinAll
    var syncableFromApi: Bool = true
    var blockchairChainId: String = "bitcoin/testnet"

    let dnsSeeds = [
        "testnet-seed.bitcoin.petertodd.org", // Peter Todd
        "testnet-seed.bitcoin.jonasschnelli.ch", // Jonas Schnelli
        "testnet-seed.bluematt.me", // Matt Corallo
        "seed.testnet.bitcoin.sprovoost.nl",
        "bitcoin-testnet.bloqseeds.net", // Bloq
    ]
    
//    "id": "00000000000021679132bef28666433e26f8ad5dbf5e9123337bc7f1c78204d7",
//    "height": 2578921,
//    "version": 1073676288,
//    "timestamp": 1708493135,
//    "tx_count": 3841,
//    "size": 1512319,
//    "weight": 3066469,
//    "merkle_root": "f86ee80dc673ae944dcdd1c7be16c559d2fde054ca3984d1bb07f93bb1c70cdb",
//    "previousblockhash": "000000000000438b1f4e10e82266d1a391b5d700d32a7f4db3816148f3a85f80",
//    "mediantime": 1708488611,
//    "nonce": 560985560,
//    "bits": 486604799,
//    "difficulty": 1
    
    
//    "id": "00000000000000c6b870e48db88b5f0eea89deed6f01135ad94bfd04a2cc9f4a",
//    "height": 2530080,
//    "version": 536870912,
//    "timestamp": 1696472066,
//    "tx_count": 52,
//    "size": 17098,
//    "weight": 52864,
//    "merkle_root": "7a578ff1b402141d6bba335ecce5fd512e454aa061aa7804d31fd41ffb764575",
//    "previousblockhash": "00000000000002395eb7f05c543dbbc241cd4b5d64b3c948f64d8ac2083b197c",
//    "mediantime": 1696469996,
//    "nonce": 3870556797,
//    "bits": 436268172,
//    "difficulty": 18156662
    
//    "id": "0000000000000018e89e7817899f6c3e20c631177a775aaf95ff403979d26b39",
//    "height": 2578621,
//    "version": 570425344,
//    "timestamp": 1708306641,
//    "tx_count": 257,
//    "size": 104103,
//    "weight": 246603,
//    "merkle_root": "c82ba60771297156b1775702c97173e91053cc04178913ada2c32a34b08c8f4b",
//    "previousblockhash": "0000000000000013970bf11e7dbb711d66158b569fc5cf577ed1a40a6a8437df",
//    "mediantime": 1708302643,
//    "nonce": 3139050834,
//    "bits": 422051352,
//    "difficulty": 107392535
    let lastCheckpoint = Checkpoint(block: .init(withHeader: .init(version: 570425344, headerHash: Data(Data(hex: "0000000000000018e89e7817899f6c3e20c631177a775aaf95ff403979d26b39").reversed()) , previousBlockHeaderHash: Data(Data(hex: "0000000000000013970bf11e7dbb711d66158b569fc5cf577ed1a40a6a8437df").reversed()), merkleRoot: Data(Data(hex: "c82ba60771297156b1775702c97173e91053cc04178913ada2c32a34b08c8f4b").reversed()), timestamp: 1708306641, bits: 422051352, nonce: 3139050834), height: 2578621), additionalBlocks: [])

    let dustRelayTxFee = 3000 // https://github.com/bitcoin/bitcoin/blob/c536dfbcb00fb15963bf5d507b7017c241718bf6/src/policy/policy.h#L50
}

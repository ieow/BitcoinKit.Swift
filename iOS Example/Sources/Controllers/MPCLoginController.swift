import HdWalletKit
import UIKit
import CryptoSwift
import mpc_core_kit_swift
import BitcoinCore
import SwiftUI

let memory = UserStorage()
//let memory = MemoryStorage()
var web3AuthClientId = "BPi5PB_UiIZ-cPz1GtV5i1I2iOSOHuimiXBI0e-Oe_u6X3oVAbCiAZOTEBtTXw4tsluTITPqA8zMsfxIKMjiqNQ"
//var hashPrefixOverwrite = "519228911939-cri01h55lsjbsia1k7ll6qpalrus75ps.apps.googleusercontent.com"

var googleClientId = "519228911939-cri01h55lsjbsia1k7ll6qpalrus75ps.apps.googleusercontent.com"
var globalVerifier = "w3a-google-demo"
//var googleClientId = "221898609709-obfn3p63741l5333093430j3qeiinaa8.apps.googleusercontent.com"
//var globalVerifier = "google-lrc"


//case .bip44: return .p2pkh
//case .bip49: return .p2wpkhSh
//case .bip84: return .p2wpkh
//case .bip86: return .p2tr


var mpcCoreKitInstance = MpcCoreKit(web3AuthClientId: web3AuthClientId, web3AuthNetwork: .sapphire(.SAPPHIRE_DEVNET) , localStorage: memory )

class MPCLoginController: UIViewController {

    @IBOutlet weak var RecoveryView: UIView!
    @IBOutlet weak var RecoveryText: UITextField!
    
    @IBOutlet weak var LoginOauthButton: UIButton!
    @IBOutlet weak var textConsole: UITextView!
    
    @IBOutlet weak var WalletType: UIButton!
    
    @IBOutlet weak var ResetButton: UIButton!
    
    func updateWalletType( action: UIAction ) {
        print(action)
        let ptype : Purpose =  switch action.discoverabilityTitle {
        case "bip44" : Purpose.bip44 ;
        case "bip49" : Purpose.bip49 ;
        case "bip84" : Purpose.bip84 ;
        case "bip86" : Purpose.bip86 ;
        default : Purpose.bip44;
        }
        let purpose = ptype
        Configuration.shared.purpose = purpose
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecoveryView.isHidden = true
        ResetButton.isHidden = true

        title = "BitcoinKit Demo"
        textConsole.text = ""
        
        
        WalletType.menu = UIMenu( children: [
            UIAction( title: "BIP84 : p2wpkh",discoverabilityTitle: Purpose.bip84.description , handler: updateWalletType ),
            UIAction( title: "BIP49 : p2wpkhSh",discoverabilityTitle: Purpose.bip49.description , handler: updateWalletType ),
            UIAction( title: "BIP44 : p2pkh", discoverabilityTitle: Purpose.bip44.description , handler: updateWalletType ),
            UIAction( title: "BIP86 : p2tr", discoverabilityTitle: Purpose.bip86.description ,attributes: .disabled, handler: updateWalletType )
        ] )
    }
    
    @IBAction func recovery(_ sender: Any) {
        guard let text = RecoveryText.text else {
            return
        }
        print(text)
        Task {
            // loading
            do {
                try await mpcCoreKitInstance.inputFactor(factorKey: text)
                self.login()
            } catch {
                let errorBlock: (Error) -> Void = { [weak self] error in
                    let alert = UIAlertController(title: "Validation Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self?.present(alert, animated: true)
                }
                errorBlock(error)
            }
//             done loading
        }
    }
    
    func login () {
        
        Manager.shared.login(apiSigner: mpcCoreKitInstance, syncModeIndex: 1 )
        if let window = UIApplication.shared.windows.filter(\.isKeyWindow).first {
            let mainController = MainController()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = mainController
            })
        }
    }
    
    @IBAction func loginOauth(_ sender: Any) {

        Task { @MainActor in
            let errorBlock: (Error) -> Void = { [weak self] error in
                let alert = UIAlertController(title: "Validation Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alert, animated: true)
            }
            
            let result = try? await mpcCoreKitInstance.login(loginProvider: .google, clientId: googleClientId, verifier: globalVerifier)
             
            guard let result = result else {
                ResetButton.isHidden = false
                errorBlock("login SSS failed")
                return
            }
            
//            if result.requiredFactors >= 0 {
            if result.requiredFactors > 0 {
                // request recover factor key
                RecoveryView.isHidden = false
                ResetButton.isHidden = false
                textConsole.text = try String(data: JSONEncoder().encode(result), encoding: .utf8)
//                textConsole.text = try String(data : JSONSerialization.data(withJSONObject: result), encoding: .utf8 )
                
            } else {
                self.login()
            }
            
            LoginOauthButton.isOpaque = true
        }
    }
    
    @IBAction func handleReset(_ sender: Any) {
        Task {
            // loading ui
            print("reseting...")
            try await mpcCoreKitInstance.resetAccount()
            print("reseting done...")
        }
    }
    
}

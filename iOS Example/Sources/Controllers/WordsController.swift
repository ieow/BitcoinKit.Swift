import HdWalletKit
import UIKit
import CryptoSwift
import mpc_core_kit_swift

//let memory = MemoryStorage()
////let mpcCoreKitInstance = MpcCoreKit(web3AuthClientId: "no id", web3AuthNetwork: .sapphire(.SAPPHIRE_DEVNET), localStorage: memory)
//var mpcCoreKitInstance = MpcCoreKit(web3AuthClientId: "221898609709-obfn3p63741l5333093430j3qeiinaa8.apps.googleusercontent.com", web3AuthNetwork: .sapphire(.SAPPHIRE_DEVNET) , localStorage: memory )

class WordsController: UIViewController {
    @IBOutlet var textView: UITextView?
    @IBOutlet var wordListControl: UISegmentedControl!
    @IBOutlet var syncModeListControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "BitcoinKit Demo"

        textView?.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView?.layer.cornerRadius = 8

        textView?.text = Configuration.shared.defaultWords[wordListControl.selectedSegmentIndex]
        updateWordListControl()
    }

    func updateWordListControl() {
        let accountCount = Configuration.shared.defaultWords.count
        guard accountCount > 1 else {
            wordListControl.isHidden = true
            return
        }
        wordListControl.removeAllSegments()
        for index in 0 ..< accountCount {
            wordListControl.insertSegment(withTitle: "\(accountCount - index)", at: 0, animated: false)
        }
        wordListControl.selectedSegmentIndex = 0
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        view.endEditing(true)
    }

    @IBAction func changeWordList(_: Any) {
        textView?.text = Configuration.shared.defaultWords[wordListControl.selectedSegmentIndex]
    }

    @IBAction func generateNewWords() {
        if let generatedWords = try? Mnemonic.generate() {
            textView?.text = generatedWords.joined(separator: " ")
            wordListControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }

    @IBAction func login() {
        Task { @MainActor in
            guard let text = textView?.text else {
                return
            }
                        
            let result1 = try? await mpcCoreKitInstance.login(loginProvider: .google, clientId: googleClientId, verifier: "google-lrc")
            
            let successBlock = { [weak self] in
//                Manager.shared.login(restoreData: text, syncModeIndex: self?.syncModeListControl.selectedSegmentIndex ?? 0)
                
//                Manager.shared.login(apiSigner: apiSigner , syncModeIndex: self?.syncModeListControl.selectedSegmentIndex ?? 0)
//                let pkey = Data(hex: "2b5f58d8e340f1ab922e89b3a69a68930edfe51364644a456335e179bc130128")
//                let apiSigner = try! HDApiSigner(privateKey: pkey)
                Manager.shared.login(apiSigner: mpcCoreKitInstance , syncModeIndex: self?.syncModeListControl.selectedSegmentIndex ?? 0)
                
                
                
                if let window = UIApplication.shared.windows.filter(\.isKeyWindow).first {
                    let mainController = MainController()
                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        window.rootViewController = mainController
                    })
                }
            }
            
            let errorBlock: (Error) -> Void = { [weak self] error in
                let alert = UIAlertController(title: "Validation Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alert, animated: true)
            }
            
            let mnemonicWords = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
            if mnemonicWords.count > 1 {
                do {
                    try Mnemonic.validate(words: mnemonicWords)
                    successBlock()
                } catch {
                    errorBlock(error)
                }
            } else {
                do {
                    _ = try HDExtendedKey(extendedKey: text)
                    successBlock()
                } catch {
                    errorBlock(error)
                }
            }
        }
    }
}

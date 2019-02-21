//
//  SynchableChainViewController.swift
//  SecurityChecks
//
//  Created by Vitor do Nascimento Rodrigues on 10/23/18.
//  Copyright © 2018 Vitor do Nascimento Rodrigues. All rights reserved.
//

import UIKit
import KeychainSwift
import CryptoSwift

class SynchableChainViewController: UIViewController {
   
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var secretText: UITextField!
    @IBOutlet weak var status: UILabel!
    
    let keyPrefix = "sync"
    let key = "keychain-synchablekey"
    let salt = "KSdA(q23uUq==d"
    let iv = "NonShallKnowThis" // This should be encripted as bytes
    
    var keychain: KeychainSwift!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keychain = KeychainSwift(keyPrefix: keyPrefix)
        keychain.synchronizable = true
    }
    
    @IBAction func didTapLoad(_ sender: Any) {
        let cypher = secretText.text!
        guard let textData = keychain.getData(key)?.bytes else {
            status.text = "EMPTY KEY"
            codeText.text = ""
            return
        }
        
        do {
            let password: Array<UInt8> = Array(cypher.utf8)
            let salt: Array<UInt8> = Array(self.salt.utf8)
            let key = try HKDF(password: password, salt: salt, variant: .sha256).calculate()
            
            // Get the AES cypher
            let aes = try AES(key: key, blockMode: CBC(iv: iv.bytes))
            // Decrypt the secured data
            let array = try aes.decrypt(textData)
            let data = Data(bytes: array)
            let text = String(data: data, encoding: .utf8)
            if text != nil {
                codeText.text = text
                status.text = "LOADED"
            } else {
                status.text = "INVALID SECRET"
            }
        } catch {
            codeText.text = ""
            status.text = "CANNOT DECRYPT\n\(error)"
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        
        if let text = codeText.text, !text.isEmpty {
            let cypher = secretText.text!
            do {
                let password = cypher.bytes
                let salt = self.salt.bytes
                let hkdf = try HKDF(password: password, salt: salt, variant: .sha256)
                let key = try hkdf.calculate()
                let aes = try AES(key: key, blockMode: CBC(iv: iv.bytes))
                let array = try aes.encrypt(text.bytes)
                let data = Data(bytes: array)
                
                keychain.set(data,
                             forKey: self.key,
                             withAccess: .accessibleWhenUnlocked)
                status.text = "SAVED"
            } catch {
                status.text = "CAN NOT SAVE!\n\(error)"
            }
        } else {
            status.text = "WRITE SOMETHING FIRST"
        }
    }
    
    @IBAction func didTapRemove(_ sender: Any) {
        if keychain.delete(key) {
            status.text = "REMOVED"
        } else {
            status.text = "ERROR TO REMOVE"
        }
    }

}

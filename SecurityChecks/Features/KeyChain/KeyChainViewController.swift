//
//  KeyChainViewController.swift
//  SecurityChecks
//
//  Created by Vitor do Nascimento Rodrigues on 10/23/18.
//  Copyright © 2018 Vitor do Nascimento Rodrigues. All rights reserved.
//

import UIKit
import KeychainSwift

class KeyChainViewController: UIViewController {

    @IBOutlet weak var secretText: UITextField!
    @IBOutlet weak var status: UILabel!
    
    let keyPrefix = ""
    let key = "keychain-key"
    
    var keychain: KeychainSwift!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keychain = KeychainSwift(keyPrefix: keyPrefix)
    }

    @IBAction func didTapLoad(_ sender: Any) {
        let text = keychain.get(key)
        secretText.text = text
        if text != nil {
            status.text = "LOADED"
        } else {
            status.text = "EMPTY KEY"
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        
        if let text = secretText.text, !text.isEmpty {
            keychain.set(text,
                         forKey: key,
                         withAccess: .accessibleWhenUnlocked)
            status.text = "SAVED"
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

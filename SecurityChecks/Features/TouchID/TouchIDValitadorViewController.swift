//
//  TouchIDValitadorViewController.swift
//  SecurityChecks
//
//  Created by Vitor do Nascimento Rodrigues on 8/31/18.
//  Copyright © 2018 Vitor do Nascimento Rodrigues. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDValitadorViewController: UIViewController {
    
    let auth = LocalAuth()
    
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    init() {
        super.init(nibName: "TouchIDValitadorViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "InviteFriendsViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapAuthenticate(_ sender: Any) {
        auth.requestAuthorization(reason: "Confirme sua identidade") { (status, error) in
            if let error = error {
                self.handleError(error)
            } else {
                self.updateLabelWithStatus(status)
            }
        }
    }
    
    private func updateLabelWithStatus(_ status: LocalAuth.AuthenticationStatus) {
        switch status {
        case .authenticated:
            statusLabel.text = "Authenticated, it's you!"
            statusLabel.textColor = .green
        case .denied:
            statusLabel.text = "Try another method"
            statusLabel.textColor = .red
        default:
            statusLabel.text = "TouchID indisponível :("
        }
    }
    
    private func handleError(_ error: LAError) {
        switch error.code {
        case .authenticationFailed:
            statusLabel.text = "Denied! You're not you! 🙅‍♂️"
        case .passcodeNotSet:
            statusLabel.text = "Device with no password! 😱"
        case .userFallback:
            statusLabel.text = "No other choice for you! 🚫"
        case .userCancel:
            statusLabel.text = "Y u cancelled? 😠"
        case .systemCancel, .appCancel:
            print("Cancelled by another app or the system")
        case .biometryNotAvailable:
            statusLabel.text = "Biometry not available, sir!"
        case .biometryNotEnrolled:
            statusLabel.text = "Device with no biometry set! 💁‍♂️"
        default:
            print("Dunno... \(error.code)")
        }
        
        statusLabel.textColor = .red
    }
}

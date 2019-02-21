//
//  LocalAuth.swift
//  SecurityChecks
//
//  Created by Vitor do Nascimento Rodrigues on 8/31/18.
//  Copyright © 2018 Vitor do Nascimento Rodrigues. All rights reserved.
//

import Foundation
import LocalAuthentication

class LocalAuth {
    
    enum AuthenticationStatus {
        case disabled
        case denied
        case authenticated
    }
    
    var newContext: LAContext { return LAContext() }
    
    /// `true` if the user has a device with biometric authentication
    var isBiometricEnabled: Bool {
        let context = newContext
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    /// `true` if the user has set a password in its device
    var isPasswordEnabled: Bool {
        let context = newContext
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    func requestAuthorization(reason: String = "Precisamos verificar sua identidade", completion: @escaping (AuthenticationStatus, LAError?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                (success, error) in
                DispatchQueue.main.async {
                    let status: AuthenticationStatus = success ? .authenticated : .denied
                    let error = error as? LAError
                    completion(status, error)
                }
            }
        } else {
            completion(.disabled, error as? LAError)
        }
    }
}

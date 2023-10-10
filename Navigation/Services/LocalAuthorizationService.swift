//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Diego Abramoff on 04.10.23.
//

import Foundation
import LocalAuthentication
import UIKit

class LocalAuthorizationService {
    
    private var canEvaluateBiometrics = false
    private lazy var context = LAContext()
    private let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {

        canEvaluatePolicy { canEvaluatePolicy in
            Task {
                switch canEvaluatePolicy {
                case true:
                    self.context.evaluatePolicy(self.policy, localizedReason: "DO SOMETHING!") {
                        success, error in
                        
                        DispatchQueue.main.async {
                            if success {
                                authorizationFinished(true)
                            } else {
                                print("ЧТО-ТО ПОШЛО НЕ ТАК С БИОМЕТРИЕЙ")
                            }
                        }
                    }
                case false:
                    authorizationFinished(false)
                }
            }
        }
    }
    
    private func canEvaluatePolicy(completion: @escaping (Bool) -> Void) {
        var error: NSError? = nil
        canEvaluateBiometrics = context.canEvaluatePolicy(policy, error: &error)
        
        if let error {
            print("Невозможно использовать биометрию. Error = \(error.localizedDescription)")
            completion(false)
        } else {
            completion(true)
        }
    }

}

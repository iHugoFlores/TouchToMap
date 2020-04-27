//
//  LoginViewController.swift
//  TouchToMap
//
//  Created by Hugo Flores Perez on 4/27/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import LocalAuthentication
import UIKit

class LoginViewController: UIViewController {
    private let authContext = LAContext()
    
    private let viewObj = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .cyan
        navigationController?.navigationBar.isHidden = true
        view = viewObj
        checkAuthMethods()
    }
    
    func canEvaluatePolicy() -> Bool {
      return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func checkAuthMethods() {
        guard canEvaluatePolicy() else {
            viewObj.setLoginText(title: "Error", description: "Biometrics are required to continue")
            return
        }
        let title = authContext.biometryType == LABiometryType.faceID ? "Login with Face ID" : "Login with Touch ID"
        let icon = authContext.biometryType == LABiometryType.faceID ? "faceid" : "hand.thumbsup"
        self.viewObj.setLoginActionContent(buttonTitle: title, imageName: icon)
        /*
        let reason = "Identify"
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    
                    return
                }
                switch error {
                case LAError.authenticationFailed?:
                  print("There was a problem verifying your identity.")
                case LAError.userCancel?:
                  print("You pressed cancel.")
                  self?.viewObj.setLoginText(title: "Try again", description: "Biometrics are required to continue\nClose the app and try again")
                case LAError.userFallback?:
                  print("You pressed password.")
                case LAError.biometryNotAvailable?:
                  print("Face ID/Touch ID is not available.")
                case LAError.biometryNotEnrolled?:
                  print("Face ID/Touch ID is not set up.")
                case LAError.biometryLockout?:
                  print("Face ID/Touch ID is locked.")
                default:
                  print("Face ID/Touch ID may not be configured")
                }
            }
        }
         */
    }

}

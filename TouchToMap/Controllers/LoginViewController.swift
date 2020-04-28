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
        let icon = authContext.biometryType == LABiometryType.faceID
            ? UIImage(systemName: "faceid")
            : UIImage(imageLiteralResourceName: "fingerprint")
        self.viewObj.setLoginActionContent(buttonTitle: title, image: icon!, action: authenticateWithBiometrics)
    }
    
    func authenticateWithBiometrics() {
        let reason = "Identify"
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.navigateToMapView()
                    return
                }
                switch error {
                case LAError.authenticationFailed?:
                  print("There was a problem verifying your identity.")
                    let alert = UIAlertController(title: "Authentication Failed", message: "You have failed many times to identify yourself", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                case LAError.userCancel?:
                  print("You pressed cancel.")
                  let alert = UIAlertController(title: "Authentication Failed", message: "Biometric authentication failed. Try again", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                  self?.present(alert, animated: true)
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
    }
    
    func navigateToMapView() {
        let controller = MapViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

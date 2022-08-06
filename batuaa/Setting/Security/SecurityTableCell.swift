//
//  SecurityTableCell.swift
//  batuaa
//
//  Created by Trilok Patel on 04/08/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class SecurityTableCell: UITableViewCell {
    let context = LAContext()
    var strAlertMessage = String()
    var error: NSError?
    
    let nc = NotificationCenter.default
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var btnSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupDataFromModel(model: String) {
        self.nameLabel.text = model
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_Passcode) == true {
            btnSwitch.isOn = true
            
        } else {
//                cell.btnSwitch.isOn = false
            btnSwitch.isOn = false
        }
        
    }
    
    @IBAction func btnToggle(_ sender: UISwitch) {
      //  self.authenticationWithTouchID()
        if sender.isOn {
           // pin(.create,activate: true)
            authenticationWithTouchID()
            
        } else {
            print("off")
          //  pin(.deactive,activate: false)
            UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_Passcode)
            UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_Passcode)
            UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_TouchIdCheckMark)
            nc.post(name: NSNotification.Name(rawValue: "advanceSetting"), object: nil, userInfo: nil)
        }
        
        
        
    }
    func pin(_ mode: ALMode,activate: Bool) {
      
      var options = ALOptions()
     // options.image = UIImage(named: "face")!
      options.title = "Devios Ryasnoy"
      options.isSensorsEnabled = true
      options.onSuccessfulDismiss = { (mode: ALMode?) in
          if let mode = mode {
              print("Password \(String(describing: mode))d successfully")
            UserDefaultsManager.userdefault.setBoolValue(true, key: key.UserDefaults.k_Passcode)
          } else {
              print("User Cancelled")
            UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_Passcode)
          }
      }
      options.onFailedAttempt = { (mode: ALMode?) in
          print("Failed to \(String(describing: mode))")
        UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_Passcode)
      }
        if activate {
            AppLocker.present(with: .create)
            
        } else {
            AppLocker.present(with: .deactive)
            
        }
          
//        AppLocker.present(with: .create, and: options, over:self)
    }
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"

        var authorizationError: NSError?
      //  let reason = "Authentication required to access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            DispatchQueue.main.async() {
                
                UserDefaultsManager.userdefault.setBoolValue(true, key: key.UserDefaults.k_Passcode)
                self.nc.post(name: NSNotification.Name(rawValue: "advanceSetting"), object: nil, userInfo: nil)
                let alert = UIAlertController(title: "Success", message: "Authenticated succesfully!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            
            
        } else {
            btnSwitch.isOn = false
            if let err = authorizationError {
                let strMessage = self.evaluateAuthenticationPolicyMessageForLA(errorCode: err.code)
                self.notifyUser("Error",
                                err: strMessage)
            }
        }
    }
    func setTouchID() {
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    self.strAlertMessage = "Set your face to authenticate"
                   // self.imgAuthenticate.image = UIImage(named: "face")
                    break
                case .touchID:
                    self.strAlertMessage = "Set your finger to authenticate"
                   // self.imgAuthenticate.image = UIImage(named: "touch")
                    break
                case .none:
                    print("none")
                    //description = "none"
                    break
                @unknown default:
                    print("none")
                }
            }else {
                
                // Device cannot use biometric authentication
                
                if let err = error {
                    let strMessage = self.evaluateAuthenticationPolicyMessageForLA(errorCode: err._code)
                    self.notifyUser("Error",
                                    err: strMessage)
                }
            }
        }else{
            if let err = error {
                let strMessage = self.evaluateAuthenticationPolicyMessageForLA(errorCode: err.code)
                self.notifyUser("Error",
                                err: strMessage)
            }
        }
        
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
            var message = ""
            if #available(iOS 11.0, macOS 10.13, *) {
                switch errorCode {
                    case LAError.biometryNotAvailable.rawValue:
                        message = "Authentication could not start because the device does not support biometric authentication."
                    
                    case LAError.biometryLockout.rawValue:
                        message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                    
                    case LAError.biometryNotEnrolled.rawValue:
                        message = "Authentication could not start because the user has not enrolled in biometric authentication."
                    
                    default:
                        message = "Did not find error code on LAError object"
                }
            } else {
                switch errorCode {
                    case LAError.touchIDLockout.rawValue:
                        message = "Too many failed attempts."
                    
                    case LAError.touchIDNotAvailable.rawValue:
                        message = "TouchID is not available on the device"
                    
                    case LAError.touchIDNotEnrolled.rawValue:
                        message = "TouchID is not enrolled on the device"
                    
                    default:
                        message = "Did not find error code on LAError object"
                }
            }
            
            return message;
        }
        
        func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
            
            var message = ""
            
            switch errorCode {
                
            case LAError.authenticationFailed.rawValue:
                message = "The user failed to provide valid credentials"
                
            case LAError.appCancel.rawValue:
                message = "Authentication was cancelled by application"
                
            case LAError.invalidContext.rawValue:
                message = "The context is invalid"
                
            case LAError.notInteractive.rawValue:
                message = "Not interactive"
                
            case LAError.passcodeNotSet.rawValue:
                message = "Passcode is not set on the device"
                
            case LAError.systemCancel.rawValue:
                message = "Authentication was cancelled by the system"
                
            case LAError.userCancel.rawValue:
                message = "The user did cancel"
                
            case LAError.userFallback.rawValue:
                message = "The user chose to use the fallback"

            default:
                message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
            }
            
            return message
        }
    

}

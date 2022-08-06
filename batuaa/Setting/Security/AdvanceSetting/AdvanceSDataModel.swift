//
//  AdvanceSDataModel.swift
//  batuaa
//
//  Created by Trilok Patel on 09/12/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class AdvanceSDataModel: NSObject, UITableViewDataSource {
    let context = LAContext()
    var strAlertMessage = String()
    var error: NSError?
    var viewM: AdvanceSettingViewModel?
    var navigationC: UINavigationController?
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return ((viewM?.advanceItems.count)!)
       
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSettingCell", for: indexPath) as! AdvanceSettingCell
       
            cell.setupDataFromModel(model: viewM!.advanceItems[indexPath.row])
       
        
        cell.selectionStyle = .none
        cell.accessoryType = .none
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_PasscodeCheckMark) == true {
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            }
            
        } else if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_TouchIdCheckMark) == true {
            if indexPath.row == 1 {
                cell.accessoryType = .checkmark
            }
            
        }
        
//        if indexPath.row == 1 {
//
//        } else {
//            cell.accessoryType = .disclosureIndicator
//            cell.btnSwitch.isHidden = true
//
//        }
        
        
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 50.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if indexPath.row == 0 {
            let index1 = IndexPath(row: 1, section: 0)
            tableView.cellForRow(at: index1)?.accessoryType = .none
            UserDefaultsManager.userdefault.setBoolValue(true, key: key.UserDefaults.k_PasscodeCheckMark)
            UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_TouchIdCheckMark)
        } else {
//            let index1 = IndexPath(row: 0, section: 0)
//            tableView.cellForRow(at: index1)?.accessoryType = .none
            setTouchID(tableView: tableView)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    

    func setTouchID(tableView: UITableView) {
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let index1 = IndexPath(row: 0, section: 0)
                tableView.cellForRow(at: index1)?.accessoryType = .none
                switch context.biometryType {
                case .faceID:
                    self.strAlertMessage = "Set your face to authenticate"
                    UserDefaultsManager.userdefault.setBoolValue(true, key: key.UserDefaults.k_TouchIdCheckMark)
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_PasscodeCheckMark)
                   // self.imgAuthenticate.image = UIImage(named: "face")
                    break
                case .touchID:
                    self.strAlertMessage = "Set your finger to authenticate"
                    UserDefaultsManager.userdefault.setBoolValue(true, key: key.UserDefaults.k_TouchIdCheckMark)
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_PasscodeCheckMark)
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
                let index1 = IndexPath(row: 1, section: 0)
                tableView.cellForRow(at: index1)?.accessoryType = .none
                let index0 = IndexPath(row: 0, section: 0)
                tableView.cellForRow(at: index0)?.accessoryType = .checkmark
                
                if let err = error {
                    let strMessage = self.evaluateAuthenticationPolicyMessageForLA(errorCode: err._code)
                    self.notifyUser("Error",
                                    err: strMessage)
                }
            }
        }else{
            let index1 = IndexPath(row: 1, section: 0)
            tableView.cellForRow(at: index1)?.accessoryType = .none
            let index0 = IndexPath(row: 0, section: 0)
            tableView.cellForRow(at: index0)?.accessoryType = .checkmark
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
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
             topVC = topVC!.presentedViewController
        }
        topVC?.present(alert, animated: true, completion: nil)
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
extension AdvanceSDataModel: UITableViewDelegate {
    convenience init(viewModel: AdvanceSettingViewModel, nav: UINavigationController) {
        self.init()
        viewM = viewModel
        navigationC = nav
        print(viewM!)
    }
}

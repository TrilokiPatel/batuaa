//
//  TFAOtpVC.swift
//  batuaa
//
//  Created by Trilok Patel on 05/08/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class TFAOtpVC: UIViewController {

    @IBOutlet weak var otpField: OTPFieldView!
//    let otpStackView = OTPStackView()
    var qrText = ""
    var viewModel: TwoFAViewModel?
    var navigation: UINavigationController?
    var otpString = ""
    var disableTFA = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = TwoFAViewModel(viewDelegate: self)
        self.setupOtpView()

    }
    func setupOtpView(){
        self.otpField.fieldsCount = 6
        self.otpField.fieldBorderWidth = 0
        self.otpField.cursorColor = UIColor.init(hexString: "#8D8D8D")
        
        self.otpField.displayType = .roundedCorner
        self.otpField.fieldSize = 38
        self.otpField.separatorSpace = 8
        self.otpField.shouldAllowIntermediateEditing = false
        self.otpField.fieldTextColor = UIColor.init(hexString: "#8D8D8D")
        self.otpField.defaultBackgroundColor = UIColor.init(hexString: "#F7F7F7")
        self.otpField.filledBackgroundColor = UIColor.init(hexString: "#F7F7F7")
        self.otpField.fieldFont = UIFont(name: "Muli-SemiBold", size: 18.0)!
        self.otpField.backgroundColor = .clear
        self.otpField.delegate = self
        
        self.otpField.initializeUI()
    }
    
    @IBAction func ContinueBtn(_ sender: Any) {
        if self.otpString.count < 6 {
            self.view.makeToast("Please fill all field", duration: 3.0, position: .top)
        } else {
            if disableTFA {
                self.viewModel?.TwoFADisableRestApi(parameter: ["otp": self.otpString])
            } else {
                self.viewModel?.activateTFARestApi(parameter: ["otp": self.otpString, "key": qrText])
            }
            
        }
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension TFAOtpVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.otpString = otpString
        if self.otpString.count == 6 {
            if disableTFA {
                self.viewModel?.TwoFADisableRestApi(parameter: ["otp": self.otpString])
            } else {
                self.viewModel?.activateTFARestApi(parameter: ["otp": self.otpString, "key": qrText])
            }
        }
    }
}
extension TFAOtpVC: TwoFAViewModelDelegate {
    func responseDisableTFARestAPI(object: DisableTFAModel?) {
        if object != nil {
            
            if object?.status == "success" && object?.sub_status == "null" {
                self.dismiss(animated: true, completion: nil)
                let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "TFAVerifyEmailVC") as! TFAVerifyEmailVC
                self.navigation!.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    
    func responseGetUserRestAPI(object: UserData?) {
        
    }
    
    func responseActivateRestAPI(object: ActivateTFAModel?) {
        if object != nil {
            
            if object?.status == "success" && object?.sub_status == "null" {
                self.dismiss(animated: true, completion: nil)
                let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "TFAVerifyEmailVC") as! TFAVerifyEmailVC
                self.navigation!.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    
    
    func responseTwoFARestAPI(object: TwoFAAddAPIData?) {
        
    }
    
    func showMsg(msg: String) {
        self.view.makeToast(msg, duration: 3.0, position: .top)
    }
    
    func showErrorMsg(msg: String) {
        self.view.makeToast(msg, duration: 3.0, position: .top)
    }
    
    func backLoginPage(msg: String) {
        popupAlertOnlyOkButton(title: "batuaa", message: msg) { success in
            if success {
                GlobalVariable.sharedInstance.showBack = true
                Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "NavVC", storyBoard: UIStoryboard(storyboard: .main))
                
            }
            
        }
    }
    
    
}

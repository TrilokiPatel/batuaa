//
//  TwoFAVC.swift
//  batuaa
//
//  Created by Trilok Patel on 03/08/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class TwoFAVC: UIViewController {

    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var authenticationRadioButton: KGRadioButton!
    
    @IBOutlet weak var smsRadioButton: KGRadioButton!
    
    @IBOutlet weak var noneRadioBtn: KGRadioButton!
    var viewModel: TwoFAViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = TwoFAViewModel(viewDelegate: self)
        noteLabel.attributedText = Helper.app.attributedTwoText(withString: "If you change your 2FA settings, you will be unable to withdraw anything, and place P2P sell orders for 24 hours as a security measure.", boldString: "Note: ")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.responseEmailVerify(_:)), name: NSNotification.Name(rawValue: "emailVerification"), object: nil)
        

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "emailVerification"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.restApiGetUser(parameter: [:])
        let tabBar = self.tabBarController as! TabbarController
        tabBar.hideTabBar()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         let tabBar = self.tabBarController as! TabbarController
        tabBar.showTabBar()
    }
    
    @IBAction func authenticationButton(_ sender: KGRadioButton) {
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_verifiedEmail) == true {
            smsRadioButton.isSelected = false
            noneRadioBtn.isSelected = false
            if !sender.isSelected {
//                 sender.isSelected = true
                self.viewModel?.TwoFAAddRestApi(parameter: [:])
            } else{
                
            }
            
        }else {
            popupAlert(title: "batuaa", message: "Verify Your Email") { success in
                if success {
                    self.restApiEmailVerification(parameter: [:])
                }
            }
            
        }
        
        
        
    }
    @IBAction func mobileSMSButton(_ sender: KGRadioButton) {
//        authenticationRadioButton.isSelected = false
//        noneRadioBtn.isSelected = false
        if !sender.isSelected {
//            sender.isSelected = true
        } else{
        }
        
    }
    
    @IBAction func noneBtn(_ sender: KGRadioButton) {
        authenticationRadioButton.isSelected = false
        smsRadioButton.isSelected = false
        if !sender.isSelected {
            sender.isSelected = true
//            self.viewModel?.TwoFAAddRestApi(parameter: [:])
            let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "TFAOtpVC") as! TFAOtpVC
            vc.disableTFA = true
            vc.navigation = self.navigationController
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else{
            
        }
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func responseEmailVerify(_ notification: NSNotification) {
              if let dict = notification.userInfo as NSDictionary? {
                self.view.makeToast("Your Email is verified", duration: 3.0, position: .top)
                   if dict["emailV"] != nil {
                   let obj = dict["emailV"] as AnyObject
                       UserDefaultsManager.userdefault.setBoolValue(obj["status"] as? Bool ?? false, key: key.UserDefaults.k_verifiedEmail)
                       self.viewWillAppear(true)
                       
               }
                  
              }
       }
    func restApiEmailVerification(parameter: NSDictionary) {
        ProgressView.sharedInstance.showIndicator()
                APIMethods.SharedMethod.dataRequest(with: APPUrl.emailVerifyUser, andMethod: RequestName.Post.rawValue, params: parameter, objectType: EmailVerifyUserModel.self) { (result, _)  in
                    ProgressView.sharedInstance.hideIndicator()
                    switch result {
                    case .success(let object):
                        DispatchQueue.main.async {
                            self.view.makeToast(object.msg ?? "", duration: 3.0, position: .top)
                        }
                    case .failure(let e):
                        DispatchQueue.main.async {
                            self.view.makeToast(e.localizedDescription, duration: 3.0, position: .top)
                        }
                    }
                }
        
    }
    
    
}
extension TwoFAVC: TwoFAViewModelDelegate {
    func responseDisableTFARestAPI(object: DisableTFAModel?) {
        if object?.status == "success" && object?.sub_status == "null" {
            authenticationRadioButton.isSelected = false
            smsRadioButton.isSelected = false
            noneRadioBtn.isSelected = true
        } else {
            
        }
        
    }
    
    func responseGetUserRestAPI(object: UserData?) {
        if object?.user?.verified_email == false {
            popupAlert(title: "batuaa", message: "Verify Your Email") { success in
                            if success {
                                self.restApiEmailVerification(parameter: [:])
                            }
                        }
            
        }
        if object?.user?.tfa_enabled == true {
            authenticationRadioButton.isSelected = true
        } else {
            noneRadioBtn.isSelected = true
        }
    }
    
    func responseActivateRestAPI(object: ActivateTFAModel?) {
        if object?.status == "success" && object?.sub_status == "null" {
            smsRadioButton.isSelected = false
            noneRadioBtn.isSelected = false
            authenticationRadioButton.isSelected = true
        }
        
        
    }
    
    func responseTwoFARestAPI(object: TwoFAAddAPIData?) {
        let vc = UIStoryboard(storyboard: .tabbar) .instantiateViewController(withIdentifier: "AuthenticationVC") as? AuthenticationVC
        vc?.object = object
        self.navigationController?.pushViewController(vc!, animated: true)
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

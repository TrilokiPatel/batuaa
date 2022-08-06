//
//  LoginVC.swift
//  batuaa
//
//  Created by Trilok Patel on 10/04/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit
import KeychainAccess
import Toast_Swift
import ProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var bghalfView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var googleBtn: UIButton!
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var loginBackBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bghalfView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        viewModel = LoginViewModel(loginDelegate: self)
        googleBtn.isHidden = true
        UserDefaultsManager.userdefault.setValue("", key: key.UserDefaults.k_User_AuthorizedToken)
        UserDefaultsManager.userdefault.setBoolValue(false,key: key.UserDefaults.k_User_logged_In)
//        Helper.app.setGradient(view: self.view,color1: UIColor.init(hexString: "#6200EE"), color2: UIColor.init(hexString: "#5A04D5"), angle: 180.0, alphaValue: 1)
       
    }
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: 600)

    }
    
    @IBAction func btnBack(_ sender: Any) {
        if GlobalVariable.sharedInstance.backFrom ==  "ExchangeTabbar" {
            Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "TabbarController", storyBoard: UIStoryboard(storyboard: .exchange))
            Helper.app.setSelectedIndexTabar(index: GlobalVariable.sharedInstance.exchangeTabselectedIndex)
            
        } else if GlobalVariable.sharedInstance.backFrom ==  "Tabbar" {
            Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "TabbarController", storyBoard: UIStoryboard(storyboard: .tabbar))
            Helper.app.setSelectedIndexTabar(index: GlobalVariable.sharedInstance.tabSelectedIndex)
            
        } else {
            Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "TabbarController", storyBoard: UIStoryboard(storyboard: .tabbar))
            Helper.app.setSelectedIndexTabar(index: 0)
        }
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if emailTF.text!.isBlank {
            self.view.makeToast("Email is Required", duration: 3.0, position: .top)
        } else if !emailTF.text!.isEmail {
            self.view.makeToast("Please enter valid email id", duration: 3.0, position: .top)
        } else if passwordTF.text!.isBlank {
            self.view.makeToast("Password is Required", duration: 3.0, position: .top)
        }
        else {
            let params = ["email":emailTF.text as Any, "password": passwordTF.text as Any,"mobileDeviceId":UIDevice.current.identifierForVendor?.uuidString as Any, "mToken":"rL7AYqT9CvpeK73UZQqtUaJvrBMe48ztVPqDbqwPT3KNyjAh"] as NSDictionary
                   viewModel?.restApiLogin(parameter: params)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "TabbarController", storyBoard: UIStoryboard(storyboard: .tabbar))
    }
    
    
    @IBAction func btnSignUp(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
         viewController.delegate = self
        
         self.navigationController?.pushViewController(viewController, animated: false)
    }
    @IBAction func btnForgotPassword(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ForgotPVC") as! ForgotPVC
        viewController.delegate = self
       
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    
}

extension LoginVC: resultLoginDelegate {
    
    func updateUI(status: String, msg: String, object: LoginModel?) {
        if status == "success" {
            if object?.tmpToken != nil {
                if GlobalVariable.sharedInstance.appLock == true {
                    pin(.validate,msg: msg,object: object)
                    
                } else {
                    ProgressHUD.showSucceed(msg, interaction: true)
                    let vc = UIStoryboard(storyboard: .main).instantiateViewController(withIdentifier: "GAuthenticatorVC") as! GAuthenticatorVC
                    vc.loginObject = object
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
                
                
            } else {
                self.view.makeToast(msg, duration: 3.0, position: .top)
                if GlobalVariable.sharedInstance.appLock == true {
                    pin(.validate,msg: msg,object: object)
                    
                } else {
                    UserDefaultsManager.userdefault.setBoolValue(true, key: key.UserDefaults.k_User_logged_In)
                    UserDefaultsManager.userdefault.setValue(object?.token ?? "", key: key.UserDefaults.k_User_AuthorizedToken)
                     APISocketWallet.shared.establishConnection()
                    Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "TabbarController", storyBoard: UIStoryboard(storyboard: .tabbar))
                     Helper.app.setSelectedIndexTabar(index: 0)
                    
                }
                
                
            }
            
        } else {
            self.view.makeToast(msg, duration: 3.0, position: .top)
            if status == "error" && object?.tmpToken != nil{
                let vc = UIStoryboard(storyboard: .main).instantiateViewController(withIdentifier: "GAuthenticatorVC") as! GAuthenticatorVC
                vc.loginObject = object
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    func pin(_ mode: ALMode,msg: String, object: LoginModel? ) {
      
      var options = ALOptions()
     // options.image = UIImage(named: "face")!
      options.title = "Devios Ryasnoy"
      options.isSensorsEnabled = true
      options.onSuccessfulDismiss = { (mode: ALMode?) in
          if let mode = mode {
              print("Password \(String(describing: mode))d successfully")
            ProgressHUD.showSucceed(msg, interaction: true)
            let vc = UIStoryboard(storyboard: .main).instantiateViewController(withIdentifier: "GAuthenticatorVC") as! GAuthenticatorVC
            vc.loginObject = object
            self.navigationController?.pushViewController(vc, animated: true)
            
          } else {
              print("User Cancelled")
            
          }
      }
      options.onFailedAttempt = { (mode: ALMode?) in
          print("Failed to \(String(describing: mode))")
        GlobalVariable.sharedInstance.appLock = false
      }
      
        AppLocker.present(with: .validate)
       
    }
    
    func updateUIerror(msg: String) {
        self.view.makeToast(msg, duration: 3.0, position: .top)

    }
    
}
extension LoginVC: ForgotPDelegate {
    func showPopUp(msg: String) {
       self.view.makeToast(msg, duration: 3.0, position: .top)
    }
    
}
extension LoginVC: SignUpDelegate {
    func showPup(msg: String) {
        self.view.makeToast(msg, duration: 3.0, position: .top)
    }
}
extension CAGradientLayer {
    func apply(angle : Double) {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
        
        endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
    }
}

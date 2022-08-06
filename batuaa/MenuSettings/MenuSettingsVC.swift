//
//  MenuSettingsVC.swift
//  batuaa
//
//  Created by Trilok Patel on 24/09/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class MenuSettingsVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    let titlesArray = [["KYC Verification"],["Profile", "Security"],["Accounts","Activity Log","Notifications"],["About Us","Terms and Conditions","Privacy Policy","Refund Policy"],["Learn"],["Share batuaa"],["Logout"]]
    var hideBtn = false
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.responseEmailVerify(_:)), name: NSNotification.Name(rawValue: "emailVerification"), object: nil)
        let footerView = MenuSettingFooterView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 100))
        //Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        footerView.appNamelbl.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        footerView.appVersionlbl.text = "version- \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
        
        self.tableView.tableFooterView = footerView
        GlobalVariable.sharedInstance.tabSelectedIndex = 3
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "emailVerification"), object: nil)
    }
    @objc func responseEmailVerify(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if dict["emailV"] != nil {
                self.view.makeToast("Your Email is verified", duration: 3.0, position: .top)
                let obj = dict["emailV"] as AnyObject
                UserDefaultsManager.userdefault.setBoolValue(obj["status"] as? Bool ?? false, key: key.UserDefaults.k_verifiedEmail)
                tableView.reloadData()
                
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       // let tabBar = self.tabBarController as? TabbarController
        backBtn.isHidden = true
//        if  tabBar?.selectedIndex == 3 || tabBar?.selectedIndex == 0 {
////            backBtn.isHidden = true
//        } else {
////            backBtn.isHidden = false
//            tabBar?.hideTabBar()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         let tabBar = self.tabBarController as? TabbarController
         tabBar?.showTabBar()
    }
    
    @IBAction func backButton(_ sender: Any) {
        Helper.app.backViewContoller(navVC: self.navigationController!, animated: true)
    }
    
}
extension MenuSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titlesArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as! MenuTableCell
        cell.lblTitle.text = titlesArray[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.accessoryType = .none
            cell.lblTitle.textColor = UIColor.init(hexString: "#222222")
            cell.createCustomCellDisclosureIndicator(chevronColor: .clear, disclosure: true)
            cell.verifyBtn.isHidden = false
            if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_verifiedEmail) == true  && UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_verifiedKYC) == true {
                cell.verifyBtn.setTitle("Verified", for: .normal)
                cell.verifyBtn.isUserInteractionEnabled = false
                
            } else if  UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_verifiedEmail) == false {
                cell.verifyBtn.setTitle("Verify Your Email", for: .normal)
                
                cell.verifyBtn.addTarget(self, action: #selector(kycButton), for: .touchUpInside)
                cell.verifyBtn.isUserInteractionEnabled = true
            } else {
                cell.verifyBtn.setTitle("Start KYC Process", for: .normal)
                cell.verifyBtn.addTarget(self, action: #selector(kycButton), for: .touchUpInside)
                cell.verifyBtn.isUserInteractionEnabled = true
            }
        } else {
            if indexPath.section == 6 {
                cell.lblTitle.textColor = UIColor.init(hexString: "#F44236")
                cell.createCustomCellDisclosureIndicator(chevronColor: UIColor.init(hexString: "#F44236"), disclosure: true)
            } else {
                if indexPath.section != 0 {
                    cell.lblTitle.textColor = UIColor.init(hexString: "#222222")
                    cell.createCustomCellDisclosureIndicator(chevronColor: UIColor.init(hexString: "#8D8D8D"), disclosure: true)
                }
            }
            cell.verifyBtn.isHidden = true
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openContoller(index: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    
    @objc func kycButton(sender: UIButton!){
        if sender.titleLabel?.text == "Verify Your Email" {
            popupAlert(title: "batuaa", message: "Verify Your Email") { success in
                if success {
                    self.restApiEmailVerification(parameter: [:])
                }
            }
        } else if sender.titleLabel?.text == "Start KYC Process" {
            Helper.app.makeOtherRootViewContollerWithAnimation(ViewController: "NavVC", storyBoard: UIStoryboard(storyboard: .kyc), animated: true)
        } else {
            
        }
    }
    
    
}
extension MenuSettingsVC {
    func openContoller(index: IndexPath) {
        
        if index.section == 1 && index.row == 0 {
            Helper.app.navigateController(ViewController: "ProfileVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar))
        }
        if index.section == 1 && index.row == 1 {
            Helper.app.navigateController(ViewController: "SecurityVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar))
            
        }
        if index.section == 2 && index.row == 0 {
            Helper.app.navigateController(ViewController: "BankAccountsVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar))
        }
        if index.section == 2 && index.row == 1 {
            Helper.app.navigateController(ViewController: "ActivityLogVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar))
        }
        if index.section == 2 && index.row == 2 {
            Helper.app.navigateController(ViewController: "NotificationsVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar))
        }
        if index.section == 3 && index.row == 0 {
            let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.url = "http://exchange.epung.com/about"
            vc.scTitle = "About Us"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if index.section == 3 && index.row == 1 {
            let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.url = "http://exchange.epung.com/about"
            vc.scTitle = "About Us"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if index.section == 3 && index.row == 2 {
            let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.url = "http://exchange.epung.com/privacypolicy"
            vc.scTitle = "Privacy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if index.section == 3 && index.row == 3 {
            let vc = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.url = "http://exchange.epung.com/refundpolicy"
            vc.scTitle = "Refund Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if index.section == 4 && index.row == 0 {
            
            Helper.app.navigateController(ViewController: "LearnVC", navVC: self.navigationController!, storyboard: UIStoryboard(storyboard: .tabbar))
        }
        
        if index.section == 5 && index.row == 0 {
            if let name = URL(string: "http://exchange.epung.com/"), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                self.present(activityVC, animated: true, completion: nil)
            }
        }
        if index.section == 6 && index.row == 0 {
            self.logOutApi(parameter: [:])
        }
    }
}
extension MenuSettingsVC {
    func logOutApi(parameter: NSDictionary)  {
        ProgressView.sharedInstance.showIndicator()
        APIMethods.SharedMethod.dataRequest(with: APPUrl.Logout, andMethod: RequestName.Post.rawValue, params: parameter, objectType: SignOutModel.self) { (result, _ ) in
            ProgressView.sharedInstance.hideIndicator()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_Passcode)
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_TouchIdCheckMark)
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_PasscodeCheckMark)
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_User_logged_In)
                    UserDefaultsManager.userdefault.setValue("", key: key.UserDefaults.k_User_AuthorizedToken)
                    Helper.app.makeOtherRootViewContoller(ViewController: "NavVC", storyBoard: UIStoryboard(storyboard: .main))
                   
                }
            case .failure(_):
                DispatchQueue.main.async {
                    UserDefaultsManager.userdefault.setBoolValue(false, key: key.UserDefaults.k_User_logged_In)
                    UserDefaultsManager.userdefault.setValue("", key: key.UserDefaults.k_User_AuthorizedToken)
                    Helper.app.makeOtherRootViewContoller(ViewController: "NavVC", storyBoard: UIStoryboard(storyboard: .main))
                
                }
            }
        }
    }
}
struct SignOutModel : Codable {
    let status : String?
    let sub_status : String?
    let msg : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case sub_status = "sub_status"
        case msg = "msg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        sub_status = try values.decodeIfPresent(String.self, forKey: .sub_status)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
    }

}
extension MenuSettingsVC {
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

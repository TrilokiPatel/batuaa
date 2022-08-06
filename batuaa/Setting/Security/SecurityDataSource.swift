//
//  SecurityDataSource.swift
//  batuaa
//
//  Created by Trilok Patel on 04/08/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
import UIKit

class SecurityDataSource: NSObject, UITableViewDataSource {
    
    var viewM: SecurityViewModel?
    var navigationC: UINavigationController?
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_Passcode) {
            return ((viewM?.securityItemsAdvanceSetting.count)!)
        } else {
            return ((viewM?.securityItems.count)!)
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityTableCell", for: indexPath) as! SecurityTableCell
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_Passcode) {
            cell.setupDataFromModel(model: viewM!.securityItemsAdvanceSetting[indexPath.row])
        } else {
            cell.setupDataFromModel(model: viewM!.securityItems[indexPath.row])
        }
        
        cell.selectionStyle = .none
        if indexPath.row == 1 {
            
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.btnSwitch.isHidden = true
            
        }
        
        
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 50.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Helper.app.navigateController(ViewController: "TwoFAVC", navVC: self.navigationC!, storyboard: UIStoryboard(storyboard: .tabbar), animated: true)
        }
        if indexPath.row == 2 {
            if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_Passcode) {
                Helper.app.navigateController(ViewController: "AdvanceSettingVC", navVC: self.navigationC!, storyboard: UIStoryboard(storyboard: .tabbar), animated: true)
                
                
            } else {
                Helper.app.navigateController(ViewController: "CreateNewPasswordVC", navVC: self.navigationC!, storyboard: UIStoryboard(storyboard: .tabbar), animated: true)
            }
            
        
        }
        if indexPath.row == 3 {
            Helper.app.navigateController(ViewController: "CreateNewPasswordVC", navVC: self.navigationC!, storyboard: UIStoryboard(storyboard: .tabbar), animated: true)
        }
        if indexPath.row == 1 {
        }
        
    }
    
}
extension SecurityDataSource: UITableViewDelegate {
    convenience init(viewModel: SecurityViewModel, nav: UINavigationController) {
        self.init()
        viewM = viewModel
        navigationC = nav
        print(viewM!)
    }
}

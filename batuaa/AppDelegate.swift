//
//  AppDelegate.swift
//  batuaa
//
//  Created by Trilok Patel on 09/04/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseCore
import LocalAuthentication
//
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, reloadExchangeTableViewDelegate {
    
    
    
    var window: UIWindow?
    var viewModel: ExchangeViewModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UIFont.overrideInitialize()
        IQKeyboardManager.shared.enable = true
        ConfigFile.sharedInstance.timeSocketmlive24 = Date() as NSDate
        ConfigFile.sharedInstance.timeSocketWalletUpdate = Date() as NSDate
        ConfigFile.sharedInstance.timeSocketOrder = Date() as NSDate
        ConfigFile.sharedInstance.timeSocketMarketHistory = Date() as NSDate
        ConfigFile.sharedInstance.timeSocketliveOrder = Date() as NSDate
        
        ConfigFile.sharedInstance.timeDepositScreen = Date() as NSDate
        let navVC = UIStoryboard(storyboard: .tabbar).instantiateViewController(withIdentifier: "TabbarController")
      //  let vc = UIStoryboard(storyboard: .exchange).instantiateViewController(withIdentifier: "TabbarController")
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) == true {
//            APISocketWallet.shared.establishConnection()
//            APISocketMarket.shared.establishConnection()
//        } else {
//            APISocketMarket.shared.establishConnection()
//            
//        }
        
    }
    // your kyc is underprocess. You will recive an email once kyc process is compleated
    func applicationDidEnterBackground(_ application: UIApplication) {
        // SocketHelper.shared.disconnectSocket()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_User_logged_In) == true {
            if UserDefaultsManager.userdefault.retriveBoolValue(key.UserDefaults.k_Passcode) {
                authenticationWithTouchID()
            }
        }
        
    }
    
    func reloadTableView(index: Int) {
        
    }
    
    func reloadTableView() {
        
    }
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"

        var authorizationError: NSError?
        let reason = "Authentication required to access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async() {
                        let alert = UIAlertController(title: "Success", message: "Authenticated succesfully!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    // Failed to authenticate
                    guard let error = evaluateError else {
                        return
                    }
                    self.authenticationWithTouchID()
                    print(error)
                
                }
            }
        } else {
            
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
    }
    
}


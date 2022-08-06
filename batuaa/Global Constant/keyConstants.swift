//
//  keyConstants.swift
//  example
//
//  Created by Syncrasy on 15/05/19.
//  Copyright © 2019 Trilok patel. All rights reserved.
//

import Foundation
struct key {
    static let DeviceType = "iOS"
    
    struct Beacon{
        static let ONEXUUID = "xxxx-xxxx-xxxx-xxxx"
    }
    
    struct UserDefaults {
        static let k_App_Running_FirstTime = "userRunningAppFirstTime"
        static let k_User_logged_In = "UserLoggedIn"
        static let k_User_AuthorizedToken = "AuthorizedToken"
        static let k_User_Profile = "userProfile"
        static let k_Push_Token = "pushNotificationToken"
        static let k_UserPin = "userPinGenerated"
        static var k_Name = "userName"
        static var k_userID = "userID"
        static var k_verifiedEmail = "verifiedEmail"
        static var k_verifiedKYC = "verifiedKYC"
        static var k_enableTFA   = "enableTFA"
        static var k_Passcode   = "enablePassCode"
        static var k_PasscodeCheckMark   = "PassCodeCheckMark"
        static var k_TouchIdCheckMark   = "TouchIdCheckMark"
    }
    
    struct Headers {
        static let Authorization = "Authorization"
        static let ContentType = "Content-Type"
    }
    struct Google{
        static let placesKey = "some key here"//for photos
        static let serverKey = "some key here"
    }
    
    struct ErrorMessage{
        static let listNotFound = "ERROR_LIST_NOT_FOUND"
        static let validationError = "ERROR_VALIDATION"
    }
}

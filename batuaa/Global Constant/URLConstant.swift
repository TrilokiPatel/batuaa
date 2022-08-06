//
//  URLConstant.swift
//  example
//
//  Created by Syncrasy on 15/05/19.
//  Copyright © 2019 Trilok patel. All rights reserved.
//

import Foundation
struct APPUrl {
    private struct Domains {
        
        static let Staging = "http://exchangeapi.crupeeto.com"
        static let Development = "http://exchangeapi-dev.crupeeto.com"
        static let UAT = "http://test-UAT.com"
        static let LOCAL = "192.145.1.1"
        static let QA = "testAddress.qa.com"
    }
    
    private static let Domain = Domains.Staging
    
    static let BaseUrl = Domain
  
    static var SignUp: String {
        return BaseUrl + "/auth/v1.0/signupUser"
    }
    
    static var Login: String {
        return BaseUrl + "/auth/v1.0/loginUser"
    }
    static var Logout: String {
        return BaseUrl + "/auth/v1.0/logoutUser"
    }
    static var ForgotPassWord: String {
        return BaseUrl + "/auth/v1.0/userForgotPassword"
    }
    
    static var changePassword: String {
        return BaseUrl + "/auth/changePassword"
    }
    
    static var sendPushToken: String {
        return BaseUrl + "/auth/sendPushToken"
    }
    
    // Wallet API
    static var walletPortfolio: String {
        return BaseUrl + "/wallet/v1.0/walletPortfolio"
    }
    static var getUserWallet: String {
        return BaseUrl + "/wallet/v1.0/getUserWallet"
    }
    static var getUserInfo: String {
        return BaseUrl + "/user/v1.0/getUser"
    }
    static var updateUserProfile: String {
        return BaseUrl + "/user/v1.0/updateUserProfile"
    }
    static var getAllUserOrders: String {
        return BaseUrl + "/transaction/v1.0/getAllUserOrders"
    }
    static var getLiveMarketData: String {
        return BaseUrl + "/market/v1.0/getLiveMarketData"
    }
    static var getMarket: String {
        return BaseUrl + "/market/v1.0/getMarket"
    }
    static var emailVerifyUser: String {
        return BaseUrl + "/user/v1.0/emailVerifyUser"
    }
    static var getLiveMarketOrders: String {
        return BaseUrl + "/market/v1.0/getLiveMarketOrders"
    }
    static var getMarketHistory: String {
        return BaseUrl + "/market/v1.0/getMarketHistory"
    }
    
    static var getAllCurrency: String {
        return BaseUrl + "/currency/v1.0/getAllCurrency"
    }
    static var getUserNotifications: String {
        return BaseUrl + "/user/v1.0/getUserNotifications"
    }
    static var getUserActionLogs: String {
        return BaseUrl + "/user/v1.0/getUserActionLogs"
    }
    static var generateAddress: String {
        return BaseUrl + "/wallet/v1.0/generateAddress"
    }
    // update password
    static var userChangePassword: String {
        return BaseUrl + "/user/v1.0/userChangePassword"
    }
    
    // Add 2FA
    static var addtfaUser: String {
        return BaseUrl + "/user/v1.0/addtfaUser"
    }
    static var validatetfaUser: String {
        return BaseUrl + "/auth/v1.0/validatetfaUser"
    }
    static var disabletfaUser: String {
        return BaseUrl + "/user/v1.0/disabletfaUser"
    }
    
    // KYC
    static var uploadSelfie: String {
        return BaseUrl + "/kyc/v1.0/uploadSelfie"
    }
    static var verifyPan: String {
        return BaseUrl + "/kyc/v1.0/verifyPan"
    }
    static var verifyDl: String {
        return BaseUrl + "/kyc/v1.0/verifyDl"
    }
    static var verifyAdhaar: String {
        return BaseUrl + "/kyc/v1.0/verifyAdhaar"
    }
    
    static var getKyc: String {
        return BaseUrl + "/kyc/v1.0/getKyc"
    }
    
    // Add Bank
    
    static var addNewBankAccount: String {
        return BaseUrl + "/bank/v1.0/add"
    }
    
    static var updateBankAccount: String {
        return BaseUrl + "/bank/v1.0/update-account"
    }
    static var verifyBank: String {
        return BaseUrl + "/bank/v1.0/verifyBankAccount"
    }
    static var createVirtualBankAccount: String {
        return BaseUrl + "/bank/v1.0/create-virtual-bank-account"
    }
    static var getVirtualBankAccount: String {
        return BaseUrl + "/bank/v1.0/get-virtual-bank-account"
    }
    static var getAllBankAcounts: String {
        return BaseUrl + "/bank/v1.0/get-accounts"
    }
    static var getAccounts: String {
        return BaseUrl + "/bank/v1.0/get-accounts"
    }
    static var updateAccount: String {
        return BaseUrl + "/bank/v1.0/update-account"
    }
    static var getDepositTxs: String {
        return BaseUrl + "/transaction/v1.0/getDepositTxs"
    }
    static var getWithdrawTxs: String {
        return BaseUrl + "/transaction/v1.0/getWithdrawTxs"
    }
    // Chart API
    
    static var getSymbolInfo: String {
        return BaseUrl + "/market/v1.0/getSymbolInfo?"
    }
    static var marketHistGraph: String {
        return BaseUrl + "/market/v1.0/marketHistGraph?"
    }
    
    // withdraw
    
    static var createUserOrder: String {
        return BaseUrl + "/transaction/v1.0/createUserOrder"
    }
    static var createUserWithdraw: String {
        return BaseUrl + "/transaction/v1.0/createUserWithdraw"
    }

    // Socket
    static var scocketStream: String {
        return BaseUrl + "/stream"
    }
}
enum ErrorWithSubstatus: String {
    case one = "01"
    case two = "02"
    case three = "03"
    case four = "04"
    case five = "05"
    case six = "06"
    case seven = "07"
    case eight = "08"
    case nine = "09"
    func errorMessage() -> String {
        switch self {
        case .one:
            return "Your Email is not verified. Please continue below to verify your email"
        case .two:
            return "Your mobile number is not verified. Please verify it to proced"
        case .three:
            return "You need to complete your KYC to proceed"
        case .four:
            return "Accredited level not verified"
        case .five:
            return "You have been logged out. Please login again to continue"
        case .six:
            return "You need to enter Two Factor authentication code to continue"
        case .seven:
            return "Your session is incorrect. PLease login again to continue"
        case .eight:
            return "Looks like your browser or IP has been changed. This is a security procedure. Please login again."
        case .nine:
            return "You do not have permission to this operation. Repeatedly trying might lead to temporary ban."
        
        }
    }
}

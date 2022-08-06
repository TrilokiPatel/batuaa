//
//  BankAccountModel.swift
//  batuaa
//
//  Created by Trilok Patel on 26/11/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
struct BankAccountModel : Codable {
    let status : String?
    let sub_status : String?
    let data : BankAccountData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case sub_status = "sub_status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        sub_status = try values.decodeIfPresent(String.self, forKey: .sub_status)
        data = try values.decodeIfPresent(BankAccountData.self, forKey: .data)
    }

}
struct BankAccountData : Codable {
    let status : Bool?
    let isConfirmed : Bool?
    let verificationReason : String?
    let verificationStatus : String?
    let verificationRequestNumber : String?
    let deleted : Bool?
    let _id : String?
    let userId : String?
    let accounts : [TotalBankAccounts]?
    let createdDate : String?
    let updatedDate : String?
    let __v : Int?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case isConfirmed = "isConfirmed"
        case verificationReason = "verificationReason"
        case verificationStatus = "verificationStatus"
        case verificationRequestNumber = "verificationRequestNumber"
        case deleted = "deleted"
        case _id = "_id"
        case userId = "userId"
        case accounts = "accounts"
        case createdDate = "createdDate"
        case updatedDate = "updatedDate"
        case __v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        isConfirmed = try values.decodeIfPresent(Bool.self, forKey: .isConfirmed)
        verificationReason = try values.decodeIfPresent(String.self, forKey: .verificationReason)
        verificationStatus = try values.decodeIfPresent(String.self, forKey: .verificationStatus)
        verificationRequestNumber = try values.decodeIfPresent(String.self, forKey: .verificationRequestNumber)
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        accounts = try values.decodeIfPresent([TotalBankAccounts].self, forKey: .accounts)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        updatedDate = try values.decodeIfPresent(String.self, forKey: .updatedDate)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }

}
struct TotalBankAccounts : Codable {
    let bankName : String?
    let beneficiary : String?
    let accountNumber : String?
    let ifscCode : String?
    let accountType : String?
    let file : String?
    let fileName : String?
    let primaryAccount : Bool?
    let active : Bool?
    let createdDate : String?
    let updatedDate : String?
    let _id : String?

    enum CodingKeys: String, CodingKey {

        case bankName = "bankName"
        case beneficiary = "beneficiary"
        case accountNumber = "accountNumber"
        case ifscCode = "ifscCode"
        case accountType = "accountType"
        case file = "file"
        case fileName = "fileName"
        case primaryAccount = "primaryAccount"
        case active = "active"
        case createdDate = "createdDate"
        case updatedDate = "updatedDate"
        case _id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
        beneficiary = try values.decodeIfPresent(String.self, forKey: .beneficiary)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        ifscCode = try values.decodeIfPresent(String.self, forKey: .ifscCode)
        accountType = try values.decodeIfPresent(String.self, forKey: .accountType)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        fileName = try values.decodeIfPresent(String.self, forKey: .fileName)
        primaryAccount = try values.decodeIfPresent(Bool.self, forKey: .primaryAccount)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        updatedDate = try values.decodeIfPresent(String.self, forKey: .updatedDate)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
    }

}

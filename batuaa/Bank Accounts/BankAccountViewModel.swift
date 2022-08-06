//
//  BankAccountViewModel.swift
//  batuaa
//
//  Created by Trilok Patel on 26/11/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import Foundation
protocol BankAccountViewModelDelegate {
    func responseRestAPI(object: BankAccountData?)
    func showMsg(msg: String)
    func showErrorMsg(msg: String)
    func backLoginPage(msg: String)
}
protocol BankAccountDelegate {
    func callBankAccountRestApi(parameter: NSDictionary)
}


class BankAccountViewModel {
    
    var bankAccountsDetail: BankAccountData?
    
    var sectionNames: [String] = []
    var sectionItems: [TotalBankAccounts] = []
   
    
   // var sectionItems = [[TotalBankAccounts]]()
    
    var delegate: BankAccountViewModelDelegate?
    init(viewDelegate: BankAccountViewModelDelegate) {
        delegate = viewDelegate
    }
    
}
extension BankAccountViewModel {
    func callBankAccountRestApi(parameter: NSDictionary) {
        ProgressView.sharedInstance.showIndicator()
        APIMethods.SharedMethod.dataRequest(with: APPUrl.getAccounts, andMethod: RequestName.Post.rawValue, params: parameter, objectType: BankAccountModel.self) { (result, _)  in
            ProgressView.sharedInstance.hideIndicator()
            switch result {
            case .success(let object):
                
                if object.status == "error"  {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            if object.sub_status == "05" || object.sub_status == "06" || object.sub_status == "07" || object.sub_status == "08"{
                               // self.delegate?.backLoginPage(msg: object.msg ?? "")
                                
                            } else {
                                DispatchQueue.main.async {
                                 //  self.delegate?.showErrorMsg(msg: object.msg ?? "")
                                }
                                
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.bankAccountsDetail = object.data
                        if object.data != nil {
                            self.sectionItems = object.data?.accounts ?? []
                            self.sectionNames = self.sectionItems.map{$0.bankName ?? ""}
                            
                        }
                        self.delegate?.responseRestAPI(object: object.data ?? nil)
                    }
                }
                
            case .failure(let e):
                DispatchQueue.main.async {
                    self.delegate?.showErrorMsg(msg: e.localizedDescription)
                }
            }
        }
    }
}

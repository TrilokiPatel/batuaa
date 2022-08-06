//
//  EditBankVC.swift
//  batuaa
//
//  Created by Trilok Patel on 07/12/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class EditBankVC: UIViewController, UITextFieldDelegate {
    var editModel: TotalBankAccounts?
    let nc = NotificationCenter.default
    @IBOutlet weak var txtBankName: ACFloatingTextfield!
    
    
    @IBOutlet weak var txtAcHolderName: ACFloatingTextfield!
    
    @IBOutlet weak var txtacNumber: ACFloatingTextfield!
    
    @IBOutlet weak var txtConAccountNumber: ACFloatingTextfield!
    
    @IBOutlet weak var txtIfsc: ACFloatingTextfield!
    
    @IBOutlet weak var dropDown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        txtBankName.text = editModel?.bankName
        txtAcHolderName.text = editModel?.beneficiary
        txtacNumber.text = editModel?.accountNumber
        txtConAccountNumber.text = editModel?.accountNumber
        txtIfsc.text = editModel?.ifscCode
        dropDown.delegate = self
        dropDown.optionArray = ["SAVING", "CURRENT"]
        if editModel?.accountType == "SAVING" {
            dropDown.selectedIndex = 0
            dropDown.text = dropDown.optionArray[0]
        } else {
            dropDown.selectedIndex = 1
            dropDown.text = dropDown.optionArray[1]
        }
        
        dropDown.hideOptionsWhenSelect = true
        dropDown.didSelect{(selectedText , index ,id) in
         print("Selected String: \(selectedText) \n index: \(index)")
            if index == 0 {
                self.dropDown.text = self.dropDown.optionArray[0]
            } else {
                self.dropDown.text = self.dropDown.optionArray[1]
                
            }
        }
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnSave(_ sender: Any) {
        if txtBankName.text!.isBlank {
            self.view.makeToast("Bank name is Required", duration: 3.0, position: .top)
        }
        else if txtAcHolderName.text!.isBlank {
            self.view.makeToast("Account Holder Name is Required", duration: 3.0, position: .top)
        }else if txtacNumber.text!.isBlank {
            self.view.makeToast("Account Number is Required", duration: 3.0, position: .top)
        }
        else if txtConAccountNumber.text!.isBlank {
            self.view.makeToast("Confirm Account number is Required", duration: 3.0, position: .top)
        } else if txtacNumber.text! !=  txtConAccountNumber.text! {
            self.view.makeToast("Please enter same Account Number", duration: 3.0, position: .top)
        } else if txtIfsc.text!.isBlank {
            self.view.makeToast("IFSC code is Required", duration: 3.0, position: .top)
        }
        else if dropDown.text!.isBlank {
            self.view.makeToast("Account Type is Required", duration: 3.0, position: .top)
        } else {
            
            let params = [
                "accountHolderName": txtAcHolderName.text as Any,
                "accountNumber": txtacNumber.text as Any,
                "accountType": dropDown.text as Any,
                "bankName": txtBankName.text as Any,
                "ifscCode": txtIfsc.text as Any
                ] as NSDictionary
            
            
            ProgressView.sharedInstance.showIndicator()
            APIMethods.SharedMethod.dataRequest(with: APPUrl.updateAccount, andMethod: RequestName.Post.rawValue, params: params, objectType: EditApiModel.self) { (result, _)  in
                ProgressView.sharedInstance.hideIndicator()
                switch result {
                case .success(let object):
                    
                    if object.status == "error"  {
                        DispatchQueue.main.async {
                            DispatchQueue.main.async {
                                if object.sub_status == "05" || object.sub_status == "06" || object.sub_status == "07" || object.sub_status == "08"{
                                    self.view.makeToast(object.msg, duration: 3.0, position: .top)
                                    
                                } else {
                                    DispatchQueue.main.async {
                                     //  self.delegate?.showErrorMsg(msg: object.msg ?? "")
                                        self.view.makeToast(object.msg, duration: 3.0, position: .top)
                                    }
                                    
                                }
                            }
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.nc.post(name: NSNotification.Name(rawValue: "editSetting"), object: nil, userInfo: nil)
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                    
                case .failure(let e):
                    DispatchQueue.main.async {
                        self.view.makeToast(e.localizedDescription, duration: 3.0, position: .top)
                        
                    }
                }
            }
            
        }

    }
    
    
}

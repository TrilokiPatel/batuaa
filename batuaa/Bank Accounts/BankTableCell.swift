//
//  BankTableCell.swift
//  batuaa
//
//  Created by Trilok Patel on 26/11/20.
//  Copyright © 2020 Trilok Patel. All rights reserved.
//

import UIKit

class BankTableCell: UITableViewCell {
    
    var delegate: EditDelegate?
    @IBOutlet weak var lblActivate: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var acHolderName: UILabel!
    
    @IBOutlet weak var acNumber: UILabel!
    
    @IBOutlet weak var ifscCode: UILabel!
    
    @IBOutlet weak var acType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupDataFromModel(model: TotalBankAccounts,bankDetail: BankAccountData) {
        
        self.acHolderName.text = model.beneficiary
//
        self.acNumber.text = model.accountNumber
       self.ifscCode.text = model.ifscCode
        self.acType.text = model.accountType
        if model.active! {
            self.lblActivate.text = "ACTIVE"
            self.lblActivate.backgroundColor = UIColor.init(hexString: "#56BD6C")
        } else {
            self.lblActivate.text = "INACTIVE"
            self.lblActivate.backgroundColor = UIColor.init(hexString: "#F44236")
        }
        if bankDetail.verificationStatus == "COMPLETED" && model.primaryAccount == true {
            self.btnEdit.isEnabled = false
        } else {
            self.btnEdit.isEnabled = true
        }
    }
    
}
